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
#                                  conceptSet = list("acetaminophen" = 1127433),
#                                  name = "medications")
# cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
# cdm$medications_collapsed <- cdm$medications |>
#   collapseCohorts(
#   gap = 1095,
#   name = "medications_collapsed"
# )

## -----------------------------------------------------------------------------
# cdm$medications |>
#   filter(subject_id == 1)
# cdm$medications_collapsed |>
#   filter(subject_id == 1)

## -----------------------------------------------------------------------------
# summary_attrition <- summariseCohortAttrition(cdm$medications_collapsed)
# tableCohortAttrition(summary_attrition)

