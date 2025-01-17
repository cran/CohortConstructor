## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message = FALSE, warning = FALSE, eval = FALSE--------------------
# library(CohortConstructor)
# library(dplyr)
# 
# cdm <- mockCohortConstructor(nPerson = 1000)

## ----eval = FALSE-------------------------------------------------------------
# omopgenerics::settings(cdm$cohort1)

## ----eval = FALSE-------------------------------------------------------------
# cdm$matched_cohort1 <- matchCohorts(
#   cohort = cdm$cohort1,
#   cohortId = 1,
#   name = "matched_cohort1")
# 
# omopgenerics::settings(cdm$matched_cohort1)

## ----eval = FALSE-------------------------------------------------------------
# # Original cohort
# omopgenerics::attrition(cdm$matched_cohort1) |> filter(cohort_definition_id == 1)
# 
# # Matched cohort
# omopgenerics::attrition(cdm$matched_cohort1) |> filter(cohort_definition_id == 4)

## ----eval = FALSE-------------------------------------------------------------
# omopgenerics::cohortCount(cdm$matched_cohort1)

## ----eval = FALSE-------------------------------------------------------------
# cdm$matched_cohort2 <- matchCohorts(
#   cohort = cdm$cohort1,
#   cohortId = 1,
#   name = "matched_cohort2",
#   ratio = Inf)
# 
# omopgenerics::cohortCount(cdm$matched_cohort2)

## ----eval = FALSE-------------------------------------------------------------
# cdm$matched_cohort3 <- matchCohorts(
#   cohort = cdm$cohort1,
#   cohortId = c(1,3),
#   name = "matched_cohort3",
#   ratio = 2)
# 
# omopgenerics::settings(cdm$matched_cohort3) |> arrange(cohort_definition_id)
# 
# omopgenerics::cohortCount(cdm$matched_cohort3) |> arrange(cohort_definition_id)

