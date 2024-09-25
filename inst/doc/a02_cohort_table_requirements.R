## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = TRUE, 
  message = FALSE, 
  warning = FALSE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(CohortConstructor)
library(CohortCharacteristics)
library(ggplot2)
library(dplyr)

## ----include = FALSE----------------------------------------------------------
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == ""){
  Sys.setenv("EUNOMIA_DATA_FOLDER" = file.path(tempdir(), "eunomia"))}
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))){ dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
  CDMConnector::downloadEunomiaData()  
}

## -----------------------------------------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = CDMConnector::eunomia_dir())
cdm <- CDMConnector::cdm_from_con(con, cdm_schema = "main", 
                    write_schema = c(prefix = "my_study_", schema = "main"))

## -----------------------------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

settings(cdm$medications)
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireIsFirstEntry()

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>%
  requireIsEntry(c(1,5)) 

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireIsLastEntry()

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireInDateRange(dateRange = as.Date(c("2010-01-01", "2015-01-01")))

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireMinCohortCount(minCohortCount = 1000)

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireIsFirstEntry() %>%
  requireInDateRange(dateRange = as.Date(c("2010-01-01", "2016-01-01")))

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

