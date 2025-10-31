## ----include = FALSE----------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")

knitr::opts_chunk$set(
  collapse = TRUE, 
  warning = FALSE, 
  message = FALSE,
  comment = "#>",
  eval = NOT_CRAN
)

## ----setup--------------------------------------------------------------------
# library(omock)
# library(dplyr)
# library(CodelistGenerator)
# library(CohortConstructor)
# library(CohortCharacteristics)
# library(visOmopResults)
# library(ggplot2)

## -----------------------------------------------------------------------------
# cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

## -----------------------------------------------------------------------------
# warfarin_codes <- getDrugIngredientCodes(cdm, "warfarin")
# cdm$warfarin <- conceptCohort(cdm = cdm,
#                                  conceptSet = warfarin_codes,
#                                  name = "warfarin")
# cohortCount(cdm$warfarin)

## -----------------------------------------------------------------------------
# cdm$gi_bleed <- conceptCohort(cdm = cdm,
#                               conceptSet = list("gi_bleed" = 192671L),
#                               name = "gi_bleed")

## -----------------------------------------------------------------------------
# cdm$warfarin_gi_bleed <- cdm$warfarin  |>
#   requireCohortIntersect(intersections = c(1,Inf),
#                          targetCohortTable = "gi_bleed",
#                          targetCohortId = 1,
#                          indexDate = "cohort_start_date",
#                          window = c(-Inf, 0),
#                          name = "warfarin_gi_bleed")
# 
# summary_attrition <- summariseCohortAttrition(cdm$warfarin_gi_bleed)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$warfarin_no_gi_bleed <- cdm$warfarin |>
#   requireCohortIntersect(intersections = 0,
#                          targetCohortTable = "gi_bleed",
#                          targetCohortId = 1,
#                          indexDate = "cohort_start_date",
#                          window = c(-Inf, 0),
#                          name = "warfarin_no_gi_bleed")
# 
# summary_attrition <- summariseCohortAttrition(cdm$warfarin_no_gi_bleed)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$injuries <- conceptCohort(
#   cdm = cdm,
#   name = "injuries",
#   conceptSet = list(
#     "ankle_sprain" = 81151,
#     "ankle_fracture" = 4059173,
#     "forearm_fracture" = 4278672,
#     "hip_fracture" = 4230399
#   ),
#   exit = "event_start_date"
# )
# 
# 
# cdm$warfarin_any_injury <- cdm$warfarin |>
#   requireCohortIntersect(intersections = c(1, Inf),
#                          cohortCombinationCriteria = "any",
#                          targetCohortTable = "injuries",
#                          indexDate = "cohort_start_date",
#                          window = c(-Inf, 0),
#                          name = "warfarin_any_injury")
# 
# summary_attrition <- summariseCohortAttrition(cdm$warfarin_any_injury)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$warfarin_any_injury <- cdm$warfarin |>
#   requireCohortIntersect(intersections = c(1, Inf),
#                          cohortCombinationCriteria = "all",
#                          targetCohortTable = "injuries",
#                          indexDate = "cohort_start_date",
#                          window = c(-Inf, 0),
#                          name = "warfarin_any_injury")
# 
# summary_attrition <- summariseCohortAttrition(cdm$warfarin_any_injury)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$warfarin_any_injury <- cdm$warfarin |>
#   requireCohortIntersect(intersections = c(1, Inf),
#                          cohortCombinationCriteria = c(2, Inf),
#                          targetCohortTable = "injuries",
#                          indexDate = "cohort_start_date",
#                          window = c(-Inf, 0),
#                          name = "warfarin_any_injury")
# 
# summary_attrition <- summariseCohortAttrition(cdm$warfarin_any_injury)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$warfarin_gi_bleed <- cdm$warfarin  |>
#   requireConceptIntersect(conceptSet = list("gi_bleed" = 192671),
#                          indexDate = "cohort_start_date",
#                          window = c(-Inf, 0),
#                          name = "warfarin_gi_bleed")
# 
# summary_attrition <- summariseCohortAttrition(cdm$warfarin_gi_bleed)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$warfarin_no_gi_bleed <- cdm$warfarin  |>
#   requireConceptIntersect(intersections = 0,
#                          conceptSet = list("gi_bleed" = 192671),
#                          indexDate = "cohort_start_date",
#                          window = c(-Inf, 0),
#                          name = "warfarin_no_gi_bleed")
# 
# summary_attrition <- summariseCohortAttrition(cdm$warfarin_no_gi_bleed)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$warfarin_visit <- cdm$warfarin  |>
#   requireTableIntersect(tableName = "visit_occurrence",
#                          indexDate = "cohort_start_date",
#                          window = c(-Inf, -1),
#                          name = "warfarin_visit")
# 
# summary_attrition <- summariseCohortAttrition(cdm$warfarin_visit)
# plotCohortAttrition(summary_attrition)

