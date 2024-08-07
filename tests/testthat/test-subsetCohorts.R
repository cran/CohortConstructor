test_that("subsetCohort works", {
  cdm_local <- omock::mockCdmReference() |>
    omock::mockPerson(n = 4) |>
    omock::mockObservationPeriod() |>
    omock::mockCohort(name = c("cohort1"), numberCohorts = 5, seed = 2)
  cdm <- cdm_local |> copyCdm()

  # Subset 1 cohort
  cdm$cohort2 <- subsetCohorts(cdm$cohort1, cohortId = 1, name = "cohort2")
  expect_true(unique(cdm$cohort2 |> dplyr::pull("cohort_definition_id")) == 1)
  expect_true(settings(cdm$cohort2) |> dplyr::pull("cohort_definition_id") == 1)
  expect_true(unique(attrition(cdm$cohort2) |> dplyr::pull("cohort_definition_id")) == 1)
  expect_true(all(
    cdm$cohort1 |> dplyr::filter(.data$cohort_definition_id == 1) |> dplyr::pull("cohort_start_date") |> sort() ==
      cdm$cohort2 |> dplyr::pull("cohort_start_date") |> sort()
  ))
  expect_equal(attrition(cdm$cohort1) |> dplyr::filter(.data$cohort_definition_id == 1),
               attrition(cdm$cohort2))

  # subset more than 1 cohort
  cdm$cohort3 <- subsetCohorts(cdm$cohort1, c(3,4,5), name = "cohort3")
  expect_true(all(unique(cdm$cohort3|> dplyr::pull("cohort_definition_id")) == 3:5))
  expect_true(all(settings(cdm$cohort3) |> dplyr::pull("cohort_definition_id") == 3:5))
  expect_true(all(unique(attrition(cdm$cohort3) |> dplyr::pull("cohort_definition_id")) == 3:5))
  expect_true(all(
    cdm$cohort1 |> dplyr::filter(.data$cohort_definition_id %in% 3:5) |> dplyr::pull("cohort_start_date") |> sort() ==
      cdm$cohort3 |> dplyr::pull("cohort_start_date") |> sort()
  ))
  expect_equal(attrition(cdm$cohort1) |> dplyr::filter(.data$cohort_definition_id %in% 3:5),
               attrition(cdm$cohort3))

  # same name
  cohort <- cdm$cohort1
  cdm$cohort1 <- subsetCohorts(cdm$cohort1, c(3,4,5))
  expect_true(all(unique(cdm$cohort1|> dplyr::pull("cohort_definition_id")) == 3:5))
  expect_true(all(settings(cdm$cohort1) |> dplyr::pull("cohort_definition_id") == 3:5))
  expect_true(all(unique(attrition(cdm$cohort1) |> dplyr::pull("cohort_definition_id")) == 3:5))
  expect_true(all(
    cohort |> dplyr::filter(.data$cohort_definition_id %in% 3:5) |> dplyr::pull("cohort_start_date") |> sort() ==
      cdm$cohort1 |> dplyr::pull("cohort_start_date") |> sort()
  ))
  expect_equal(attrition(cohort) |> dplyr::filter(.data$cohort_definition_id %in% 3:5),
               attrition(cdm$cohort1))

  PatientProfiles::mockDisconnect(cdm)
})

test_that("codelist works", {
  testthat::skip_on_cran()
  cdm_local <- omock::mockCdmReference() |>
    omock::mockPerson(n = 4) |>
    omock::mockObservationPeriod() |>
    omock::mockCohort()
  cdm_local$concept <- dplyr::tibble(
    "concept_id" = c(1, 2, 3),
    "concept_name" = c("my concept 1", "my concept 2", "my concept 3"),
    "domain_id" = "Drug",
    "vocabulary_id" = NA,
    "concept_class_id" = NA,
    "concept_code" = NA,
    "valid_start_date" = NA,
    "valid_end_date" = NA
  )
  cdm_local$drug_exposure <- dplyr::tibble(
    "drug_exposure_id" = 1:17,
    "person_id" = c(1, 1, 1, 1, 2, 2, 3, 1, 1, 1, 1, 4, 4, 1, 2, 3, 4),
    "drug_concept_id" = c(1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2, 3, 3, 3, 3),
    "drug_exposure_start_date" = c(0, 300, 1500, 750, 10, 800, 150, 1800, 1801, 1802, 1803, 430, -10, 100, 123, -10, 1000),
    "drug_exposure_end_date" = c(400, 800, 1600, 1550, 2000, 1000, 600, 1801, 1802, 1803, 1804, 400, -100, NA, 190, 123, 1500),
    "drug_type_concept_id" = 1
  ) |>
    dplyr::mutate(
      "drug_exposure_start_date" = as.Date(.data$drug_exposure_start_date, origin = "2010-01-01"),
      "drug_exposure_end_date" = as.Date(.data$drug_exposure_end_date, origin = "2010-01-01")
    )
  cdm_local$observation_period <- cdm_local$observation_period|>
    dplyr::mutate(observation_period_start_date = as.Date("1990-01-01"), observation_period_end_date = as.Date("2020-01-01"))

  cdm <- cdm_local |> copyCdm()

  cdm$cohort1 <- conceptCohort(cdm, conceptSet = list(c1 = c(1,3), c2 = c(2)), name = "cohort1")

  # Subset 1 cohort
  cdm$cohort2 <- subsetCohorts(cdm$cohort1, 1, name = "cohort2")
  expect_equal(attr(cdm$cohort2, "cohort_codelist") |> dplyr::collect(),
               attr(cdm$cohort1, "cohort_codelist") |> dplyr::filter(cohort_definition_id == 1) |> dplyr::collect())

  # same name
  cohort <- cdm$cohort1
  cdm$cohort1 <- subsetCohorts(cdm$cohort1, 2)
  expect_equal(attr(cdm$cohort1, "cohort_codelist") |> dplyr::collect(),
               attr(cohort, "cohort_codelist") |> dplyr::filter(cohort_definition_id == 2) |> dplyr::collect())

  PatientProfiles::mockDisconnect(cdm)
})

test_that("Expected behaviour", {
  testthat::skip_on_cran()
  cdm_local <- omock::mockCdmReference() |>
    omock::mockPerson(n = 4) |>
    omock::mockObservationPeriod() |>
    omock::mockCohort(name = c("cohort1"), numberCohorts = 5, seed = 2)
  cdm <- cdm_local |> copyCdm()

  # Subset 1 cohort
  expect_error(cdm$cohort2 <- subsetCohorts("cohort1", 1, name = "cohort2"))
  expect_error(cdm$cohort2 <- subsetCohorts(cdm$cohort1, "1", name = "cohort2"))
  expect_error(cdm$cohort2 <- subsetCohorts(cdm$cohort1, 2, name = "cohort3"))
  expect_error(cdm$cohort2 <- subsetCohorts(cdm$cohort1, 10, name = "cohort2"))
  expect_no_error(cohort <- subsetCohorts(cdm$cohort1, NULL))
  expect_identical(cohort, cdm$cohort1)

  PatientProfiles::mockDisconnect(cdm)
})

test_that("Testing minCohortCount argument", {
  testthat::skip_on_cran()
  cdm_local <- omock::mockCdmReference() |>
    omock::mockPerson(n = 1) |>
    omock::mockObservationPeriod() |>
    omock::mockCohort(name = c("cohort1"), numberCohorts = 5, seed = 2)
  cdm <- cdm_local |> copyCdm()

  # Subset 1 cohort - minCohortCount default
  cdm$subset_cohort1 <- subsetCohorts(cdm$cohort1, cohortId = 1, name = "subset_cohort1")
  expect_equal(cdm$subset_cohort1 %>%
                 dplyr::tally() %>%
                 dplyr::pull("n") %>%
                 as.numeric(), 1)

  cdm$subset_cohort1 <- subsetCohorts(cdm$cohort1, cohortId = 1, minCohortCount = 2, name = "subset_cohort1")

  expect_equal(cdm$subset_cohort1 %>%
                 dplyr::tally() %>%
                 dplyr::pull("n") %>%
                 as.numeric(), 0)

  cdm_local <- omock::mockCdmReference() |>
    omock::mockPerson(n = 2) |>
    omock::mockObservationPeriod() |>
    omock::mockCohort(name = c("cohort1"), numberCohorts = 3, seed = 2,recordPerson = c(1,2,3))

  cdm <- cdm_local |> copyCdm()

  cdm$subset_cohort1 <- subsetCohorts(cdm$cohort1, cohortId = 1, minCohortCount = 2, name = "subset_cohort1")

  expect_equal(cdm$subset_cohort1 %>%
                 dplyr::tally() %>%
                 dplyr::pull("n") %>%
                 as.numeric(), 2)

  cdm$subset_cohort1 <- subsetCohorts(cdm$cohort1, cohortId = NULL, minCohortCount = 2, name = "subset_cohort1")

  expect_equal(cdm$subset_cohort1 %>%
                 dplyr::tally() %>%
                 dplyr::pull("n") %>%
                 as.numeric(), 12)

  cdm$subset_cohort1 <- subsetCohorts(cdm$cohort1, cohortId = c(1,2), minCohortCount = 4, name = "subset_cohort1")

  expect_equal(cdm$subset_cohort1 %>%
                 dplyr::tally() %>%
                 dplyr::pull("n") %>%
                 as.numeric(), 4)

  expect_error(cdm$subset_cohort1 <- subsetCohorts(cdm$cohort1, cohortId = NULL, minCohortCount = -1, name = "cohort2"))
  expect_error(cdm$subset_cohort1 <- subsetCohorts(cdm$cohort1, cohortId = NULL, minCohortCount = Inf, name = "cohort2"))
  expect_error(cdm$subset_cohort1 <- subsetCohorts(cdm$cohort1, cohortId = NULL, minCohortCount = "one", name = "cohort2"))

  cdm$cohort1 <- cdm$cohort1 |>
    omopgenerics::newCohortTable(
      cohortSetRef = dplyr::bind_rows(
        settings(cdm$cohort1),
        dplyr::tibble(cohort_definition_id = 4, cohort_name = "cohort_4")
      ),
      cohortAttritionRef = dplyr::bind_rows(
        attrition(cdm$cohort1),
        dplyr::tibble(cohort_definition_id = 4, number_records = 0,  number_subjects = 0))
    )

  cdm$sub1 <- cdm$cohort1 |> subsetCohorts(cohortId = 1:4, name = "sub1")
  expect_equal(cdm$sub1 |> collectCohort(1), cdm$cohort1 |> collectCohort(1))
  expect_equal(cdm$sub1 |> collectCohort(2), cdm$cohort1 |> collectCohort(2))
  expect_equal(cdm$sub1 |> collectCohort(3), cdm$cohort1 |> collectCohort(3))
  expect_equal(cdm$sub1 |> collectCohort(4), cdm$cohort1 |> collectCohort(4))

  cdm$sub2 <- cdm$cohort1 |> subsetCohorts(cohortId = 4, name = "sub2")
  expect_equal(settings(cdm$sub2), dplyr::tibble(cohort_definition_id = 4, cohort_name = "cohort_4"))

  cdm$sub3 <- cdm$cohort1 |> subsetCohorts(cohortId = 4, minCohortCount = 1, name = "sub3")
  expect_true(nrow(settings(cdm$sub3)) == 0)

  PatientProfiles::mockDisconnect(cdm)
})
