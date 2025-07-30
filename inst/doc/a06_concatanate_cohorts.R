## ----include = FALSE----------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")

knitr::opts_chunk$set(
  collapse = TRUE, 
  warning = FALSE, 
  message = FALSE,
  comment = "#>",
  eval = NOT_CRAN
)

library(CDMConnector)
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == ""){
Sys.setenv("EUNOMIA_DATA_FOLDER" = file.path(tempdir(), "eunomia"))}
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))){ dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
downloadEunomiaData()  
}


## ----setup--------------------------------------------------------------------
# library(CohortConstructor)
# library(CohortCharacteristics)
# library(ggplot2)

## ----include = FALSE----------------------------------------------------------
# knitr::opts_chunk$set(
#   collapse = TRUE,
#   eval = TRUE, message = FALSE, warning = FALSE,
#   comment = "#>"
# )
# 
# library(CDMConnector)
# library(dplyr, warn.conflicts = FALSE)
# 
# if (Sys.getenv("EUNOMIA_DATA_FOLDER") == ""){
#   Sys.setenv("EUNOMIA_DATA_FOLDER" = file.path(tempdir(), "eunomia"))}
# if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))){ dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
#   downloadEunomiaData()
# }

## -----------------------------------------------------------------------------
# con <- DBI::dbConnect(duckdb::duckdb(), dbdir = eunomiaDir())
# cdm <- CDMConnector::cdmFromCon(con, cdmSchema = "main",
#                     writeSchema = "main", writePrefix = "my_study_")

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

