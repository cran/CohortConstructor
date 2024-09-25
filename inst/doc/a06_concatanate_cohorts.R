## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(CohortConstructor)
library(CohortCharacteristics)
library(ggplot2)

## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = TRUE, message = FALSE, warning = FALSE,
  comment = "#>"
)

library(CDMConnector)
library(dplyr, warn.conflicts = FALSE)

if (Sys.getenv("EUNOMIA_DATA_FOLDER") == ""){
  Sys.setenv("EUNOMIA_DATA_FOLDER" = file.path(tempdir(), "eunomia"))}
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))){ dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
  downloadEunomiaData()  
}

## -----------------------------------------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = eunomia_dir())
cdm <- cdm_from_con(con, cdm_schema = "main", 
                    write_schema = c(prefix = "my_study_", schema = "main"))

## -----------------------------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$medications_collapsed <- collapseCohorts(
  cohort = cdm$medications,
  gap = 1095,
  name = "medications_collapsed"
)

## -----------------------------------------------------------------------------
cdm$medications %>%
  filter(subject_id == 1)
cdm$medications_collapsed %>%
  filter(subject_id == 1)

## -----------------------------------------------------------------------------
summary_attrition <- summariseCohortAttrition(cdm$medications_collapsed)
plotCohortAttrition(summary_attrition, cohortId = 1)

## -----------------------------------------------------------------------------
summary_attrition <- summariseCohortAttrition(cdm$medications_collapsed)
plotCohortAttrition(summary_attrition, cohortId = 2)

