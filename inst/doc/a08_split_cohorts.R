## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = TRUE, message = FALSE, warning = FALSE,
  comment = "#>"
)

library(CohortConstructor)
library(CohortCharacteristics)
library(ggplot2)
library(CDMConnector)
library(dplyr, warn.conflicts = FALSE)
library(PatientProfiles)

if (Sys.getenv("EUNOMIA_DATA_FOLDER") == ""){
  Sys.setenv("EUNOMIA_DATA_FOLDER" = file.path(tempdir(), "eunomia"))}
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))){ dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
  downloadEunomiaData()  
}

## -----------------------------------------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = eunomiaDir())
cdm <- CDMConnector::cdmFromCon(con, cdmSchema = "main", 
                    writeSchema = "main", writePrefix = "my_study_")

## -----------------------------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$stratified <- cdm$medications |>
  addAge(ageGroup = list("Child" = c(0,17), "18 to 65" = c(18,64), "65 and Over" = c(65, Inf))) |>
  addSex(name = "stratified") |>
  stratifyCohorts(strata = list("sex", "age_group", c("sex", "age_group")), name = "stratified")

settings(cdm$stratified)

## ----include=FALSE, warning=FALSE---------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = eunomiaDir())
cdm <- cdmFromCon(con, cdmSchema = "main", 
                    writeSchema = c(prefix = "my_study_", schema = "main"))

cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

## -----------------------------------------------------------------------------
cdm$years <- cdm$medications |>
  yearCohorts(years = 2005:2010, name = "years")

settings(cdm$years)

