#' Create a new cohort table from stratifying an existing one
#'
#' @description
#' `stratifyCohorts()` creates new cohorts, splitting an existing cohort based
#' on specified columns on which to stratify on.
#'
#' @param cohort A cohort table in a cdm reference.
#' @param strata A strata list that point to columns in cohort table.
#' @param cohortId IDs of the cohorts to include. If NULL all cohorts will be
#' considered. Cohorts not included will be removed from the cohort set.
#' @param removeStrata Whether to remove strata columns from final cohort table.
#' @param name Name of the new cohort.
#'
#' @return Cohort table stratified.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(CohortConstructor)
#' library(PatientProfiles)
#'
#' cdm <- mockCohortConstructor()
#'
#' cdm$my_cohort <- cdm$cohort1 |>
#'   addAge(ageGroup = list("child" = c(0, 17), "adult" = c(18, Inf))) |>
#'   addSex() |>
#'   stratifyCohorts(
#'     strata = list("sex", c("sex", "age_group")), name = "my_cohort"
#'   )
#'
#' cdm$my_cohort
#'
#' settings(cdm$my_cohort)
#'
#' attrition(cdm$my_cohort)
#' }
stratifyCohorts <- function(cohort,
                            strata,
                            cohortId = NULL,
                            removeStrata = TRUE,
                            name = tableName(cohort)) {
  # initial checks
  cohort <- validateCohortTable(cohort = cohort)
  cohortId <- validateCohortId(cohortId, settings(cohort)$cohort_definition_id)
  strata <- validateStrata(strata, cohort)
  name <- validateName(name)

  cdm <- omopgenerics::cdmReference(cohort)

  if (length(strata) == 0 | sum(cohortCount(cohort)$number_records) == 0) {
    if (identical(name, tableName(cohort))) {
      return(cohort)
    } else {
      return(
        cohort |>
        dplyr::compute(name = name, temporary = FALSE) |>
        omopgenerics::newCohortTable(.softValidation = TRUE)
      )
    }
  }

  strataCols <- unique(unlist(strata))

  set <- settings(cohort) |>
    dplyr::filter(.data$cohort_definition_id %in% .env$cohortId) |>
    dplyr::mutate("target_cohort_table_name" = tableName(cohort)) |>
    dplyr::rename(
      "target_cohort_id" = "cohort_definition_id",
      "target_cohort_name" = "cohort_name"
    )

  # drop columns from set
  dropCols <- colnames(set)[colnames(set) %in% strataCols]
  if (length(dropCols) > 0) {
    cli::cli_inform(c(
      "!" = "{dropCols} {?is/are} present in settings and strata. Settings
      column will be not considered."
    ))
    set <- set |> dplyr::select(!dplyr::all_of(dropCols))
  }

  # get counts for attrition
  counts <- cohort |>
    dplyr::group_by(dplyr::across(dplyr::all_of(c(
      "cohort_definition_id", strataCols
    )))) |>
    dplyr::summarise(
      "number_subjects" = dplyr::n_distinct(.data$subject_id),
      "number_records" = dplyr::n(),
      .groups = "drop"
    ) |>
    dplyr::collect() |>
    dplyr::arrange(dplyr::across(dplyr::all_of(c(
      "cohort_definition_id", strataCols
    ))))

  newSettings <- getNewSettingsStrata(set, strata, counts)

  nm <- omopgenerics::uniqueTableName()
  cdm <- omopgenerics::insertTable(
    cdm = cdm,
    name = nm,
    table = newSettings |>
      dplyr::select(dplyr::all_of(c(
        "cohort_definition_id", "target_cohort_id", "strata_columns", strataCols
      )))
  )

  newCohort <- list()
  for (k in seq_along(strata)) {
    newCohort[[k]] <- cohort |>
      dplyr::rename("target_cohort_id" = "cohort_definition_id") |>
      dplyr::inner_join(
        cdm[[nm]] |>
          dplyr::filter(
            .data$strata_columns == !!paste0(strata[[k]], collapse = "; ")
          ) |>
          dplyr::select(
            "cohort_definition_id",
            "target_cohort_id",
            dplyr::all_of(strata[[k]])
          ),
        by = c("target_cohort_id", strata[[k]])
      )
  }
  newAttrition <- getNewAttritionStrata(attrition(cohort), newSettings, counts)
  newSettings <- newSettings |> dplyr::bind_rows()
  ## codelist
  codelist <- attr(cohort, "cohort_codelist")
  newCodelist <- cdm[[nm]] |>
    dplyr::select(c("cohort_definition_id", "target_cohort_id")) |>
    dplyr::inner_join(
      codelist |>
        dplyr::rename("target_cohort_id" = "cohort_definition_id"),
      by = "target_cohort_id",
      relationship = "many-to-many"
    ) |>
    dplyr::select(!"target_cohort_id")

  newCohort <- purrr::reduce(newCohort, dplyr::union_all) |>
    dplyr::select(!dplyr::all_of(c(
      "target_cohort_id", strataCols[removeStrata]
    ))) |>
    dplyr::compute(name = name, temporary = FALSE) |>
    omopgenerics::newCohortTable(
      cohortSetRef = newSettings,
      cohortAttritionRef = newAttrition,
      cohortCodelistRef = newCodelist,
      .softValidation = TRUE
    )

  omopgenerics::dropTable(cdm = cdm, name = nm)

  return(newCohort)
}

getNewSettingsStrata <- function(set, strata, counts) {
  lapply(strata, function(x) {
    values <- counts |>
      dplyr::select(dplyr::all_of(x)) |>
      as.list() |>
      lapply(unique)
    set |>
      dplyr::cross_join(
        tidyr::expand_grid(!!!values) |>
          tidyr::unite(
            col = "cohort_name", dplyr::all_of(x), sep = "_", remove = FALSE
          ) |>
          dplyr::mutate("strata_columns" = paste0(x, collapse = "; ")) |>
          dplyr::relocate("strata_columns")
      )
  }) |>
    dplyr::bind_rows() |>
    dplyr::mutate(
      "cohort_name" = paste0(.data$target_cohort_name, "_", tolower(.data$cohort_name)),
      "cohort_definition_id" = dplyr::row_number()
    )
}

getNewAttritionStrata <- function(originalAttrition, set, counts) {
  numCohorts <- nrow(set)
  newAttrition <- rep(list(originalAttrition), numCohorts)
  for (k in seq_len(numCohorts)) {
    tcdi <- set$target_cohort_id[k]
    ccdi <- set$cohort_definition_id[k]
    strata <- set$strata_columns[k] |> strsplit(split = "; ") |> unlist()
    newAttrition[[k]] <- newAttrition[[k]] |>
      dplyr::filter(.data$cohort_definition_id == .env$tcdi) |>
      dplyr::mutate("cohort_definition_id" = .env$ccdi)
    count <- counts |>
      dplyr::filter(.data$cohort_definition_id == .env$tcdi)
    for (i in seq_along(strata)) {
      strat <- strata[i]
      val <- set[[strat]][k]
      reason <- paste0("filter strata: ", strat, " == ", val)
      count <- count |>
        dplyr::filter(.data[[strat]] == .env$val)
      newAttrition[[k]] <- newAttrition[[k]] |>
        addAttritionLine(reason, count)
    }
  }
  newAttrition |> dplyr::bind_rows()
}
addAttritionLine <- function(oldAttrition, reason, count) {
  nr <- sum(count$number_records)
  ns <- sum(count$number_subjects)
  oldAttrition |>
    dplyr::union_all(
      oldAttrition |>
        dplyr::filter(.data$reason_id == max(.data$reason_id)) |>
        dplyr::mutate(
          "reason" = .env$reason,
          "excluded_records" = .data$number_records - .env$nr,
          "excluded_subjects" = .data$number_subjects - .env$ns,
          "number_records" = .env$nr,
          "number_subjects" = .env$ns,
          "reason_id" = .data$reason_id + 1
        )
    )
}
