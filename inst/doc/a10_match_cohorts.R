## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message = FALSE, warning = FALSE, eval = FALSE--------------------
#  library(CohortConstructor)
#  library(dplyr)
#  
#  cdm <- mockCohortConstructor(nPerson = 1000)

## ----eval = FALSE-------------------------------------------------------------
#  CDMConnector::cohort_set(cdm$cohort1)

## ----eval = FALSE-------------------------------------------------------------
#  cdm$matched_cohort1 <- matchCohorts(
#    cohort = cdm$cohort1,
#    cohortId = 1,
#    name = "matched_cohort1")
#  
#  CDMConnector::cohort_set(cdm$matched_cohort1)

## ----eval = FALSE-------------------------------------------------------------
#  # Original cohort
#  CDMConnector::cohort_attrition(cdm$matched_cohort1) %>% filter(cohort_definition_id == 1)
#  
#  # Matched cohort
#  CDMConnector::cohort_attrition(cdm$matched_cohort1) %>% filter(cohort_definition_id == 4)

## ----eval = FALSE-------------------------------------------------------------
#  CDMConnector::cohort_count(cdm$matched_cohort1)

## ----eval = FALSE-------------------------------------------------------------
#  cdm$matched_cohort2 <- matchCohorts(
#    cohort = cdm$cohort1,
#    cohortId = 1,
#    name = "matched_cohort2",
#    ratio = Inf)
#  
#  CDMConnector::cohort_count(cdm$matched_cohort2)

## ----eval = FALSE-------------------------------------------------------------
#  cdm$matched_cohort3 <- matchCohorts(
#    cohort = cdm$cohort1,
#    cohortId = c(1,3),
#    name = "matched_cohort3",
#    ratio = 2)
#  
#  CDMConnector::cohort_set(cdm$matched_cohort3) %>% arrange(cohort_definition_id)
#  
#  CDMConnector::cohort_count(cdm$matched_cohort3) %>% arrange(cohort_definition_id)

