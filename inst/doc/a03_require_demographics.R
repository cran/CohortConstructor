## ----include = FALSE----------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")

knitr::opts_chunk$set(
  collapse = TRUE, 
  warning = FALSE, 
  message = FALSE,
  comment = "#>",
  eval = NOT_CRAN
)

## -----------------------------------------------------------------------------
# library(CodelistGenerator)
# library(CohortConstructor)
# library(CohortCharacteristics)
# library(ggplot2)
# library(omock)
# library(dplyr)

## -----------------------------------------------------------------------------
# cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

## -----------------------------------------------------------------------------
# fracture_codes <- getCandidateCodes(cdm, "fracture")
# fracture_codes <- list("fracture" = fracture_codes$concept_id)
# cdm$fracture <- conceptCohort(cdm = cdm,
#                                  conceptSet = fracture_codes,
#                                  name = "fracture")
# 
# summary_attrition <- summariseCohortAttrition(cdm$fracture)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$fracture <- cdm$fracture |>
#   requireAge(indexDate = "cohort_start_date",
#              ageRange = list(c(18, 100)))
# 
# summary_attrition <- summariseCohortAttrition(cdm$fracture)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$fracture <- cdm$fracture |>
#   requireSex(sex = "Female")
# 
# summary_attrition <- summariseCohortAttrition(cdm$fracture)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$fracture <- cdm$fracture |>
#   requirePriorObservation(indexDate = "cohort_start_date",
#                           minPriorObservation = 365)
# 
# summary_attrition <- summariseCohortAttrition(cdm$fracture)
# plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
# cdm$fracture <- conceptCohort(cdm = cdm,
#                                  conceptSet = fracture_codes,
#                                  name = "fracture") |>
#   requireDemographics(indexDate = "cohort_start_date",
#                       ageRange = c(18,100),
#                       sex = "Female",
#                       minPriorObservation = 365,
#                       minFutureObservation = 30)
# 
# summary_attrition <- summariseCohortAttrition(cdm$fracture)
# plotCohortAttrition(summary_attrition)

