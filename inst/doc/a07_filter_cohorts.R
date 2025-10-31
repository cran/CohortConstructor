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
# library(CohortConstructor)
# library(CohortCharacteristics)
# library(ggplot2)

## -----------------------------------------------------------------------------
# cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

## -----------------------------------------------------------------------------
# cdm$medications <- conceptCohort(cdm = cdm,
#                                  conceptSet = list("diclofenac" = 1124300,
#                                                    "acetaminophen" = 1127433),
#                                  name = "medications")
# cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
# cdm$medications |> sampleCohorts(cohortId = NULL, n = 100)
# 
# cohortCount(cdm$medications)

## ----include = FALSE, warning = FALSE-----------------------------------------
# cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")
# 
# cdm$medications <- conceptCohort(cdm = cdm,
#                                  conceptSet = list("diclofenac" = 1124300,
#                                                    "acetaminophen" = 1127433),
#                                  name = "medications")

## -----------------------------------------------------------------------------
# cdm$medications <- cdm$medications |> sampleCohorts(cohortId = 2, n = 100)
# 
# cohortCount(cdm$medications)

## ----include = FALSE, warning = FALSE-----------------------------------------
# cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")
# 
# cdm$medications <- conceptCohort(cdm = cdm,
#                                  conceptSet = list("diclofenac" = 1124300,
#                                                    "acetaminophen" = 1127433),
#                                  name = "medications")

## -----------------------------------------------------------------------------
# cdm$medications <- cdm$medications |> subsetCohorts(cohortId = 2)
# cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
# cdm$medications <- cdm$medications |> sampleCohorts(cohortId = 2, n = 100)
# 
# cohortCount(cdm$medications)

