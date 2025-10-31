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
# cdm$medintersect <- intersectCohorts(
#   cohort = cdm$medications,
#   name = "medintersect"
# )
# 
# cohortCount(cdm$medintersect)

## ----include=FALSE, warning=FALSE---------------------------------------------
# cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")
# 
# cdm$medications <- conceptCohort(cdm = cdm,
#                                  conceptSet = list("diclofenac" = 1124300,
#                                                    "acetaminophen" = 1127433),
#                                  name = "medications")

## -----------------------------------------------------------------------------
# cdm$medintersect <- intersectCohorts(
#   cohort = cdm$medications,
#   gap = 365,
#   name = "medintersect"
# )
# 
# cohortCount(cdm$medintersect)

## -----------------------------------------------------------------------------
# cdm$medunion <- unionCohorts(
#   cohort = cdm$medications,
#   name = "medunion"
# )
# 
# cohortCount(cdm$medunion)

## ----include=FALSE, warning=FALSE---------------------------------------------
# cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")
# 
# cdm$medications <- conceptCohort(cdm = cdm,
#                                  conceptSet = list("diclofenac" = 1124300,
#                                                    "acetaminophen" = 1127433),
#                                  name = "medications")

## -----------------------------------------------------------------------------
# cdm$medunion <- unionCohorts(
#   cohort = cdm$medications,
#   name = "medunion",
#   keepOriginalCohorts = TRUE
# )
# 
# cohortCount(cdm$medunion)

## ----include=FALSE, warning=FALSE---------------------------------------------
# cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")
# 
# cdm$medications <- conceptCohort(cdm = cdm,
#                                  conceptSet = list("diclofenac" = 1124300,
#                                                    "acetaminophen" = 1127433),
#                                  name = "medications")

## -----------------------------------------------------------------------------
# cdm$medunion <- unionCohorts(
#   cohort = cdm$medications,
#   name = "medunion",
#   gap = 365,
#   keepOriginalCohorts = TRUE
# )
# 
# cohortCount(cdm$medunion)

