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

settings(cdm$medications)
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireAge(indexDate = "cohort_start_date",
             ageRange = list(c(18,100)))

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

settings(cdm$medications)
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireSex(sex = "Female")

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

settings(cdm$medications)
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requirePriorObservation(indexDate = "cohort_start_date",
                          minPriorObservation = 365)

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

settings(cdm$medications)
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireFutureObservation(indexDate = "cohort_start_date",
                          minFutureObservation = 365)

summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

settings(cdm$medications)
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireDemographics(indexDate = "cohort_start_date",
                      ageRange = c(18,100),
                      sex = "Female",
                      minPriorObservation = 365,
                      minFutureObservation = 365)



summary_attrition <- summariseCohortAttrition(cdm$medications)
plotCohortAttrition(summary_attrition, cohortId = 1)

