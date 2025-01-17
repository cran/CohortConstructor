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
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = eunomiaDir())
cdm <- cdmFromCon(con, cdmSchema = "main", 
                    writeSchema = c(prefix = "my_study_", schema = "main"))

## -----------------------------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$medintersect <- CohortConstructor::intersectCohorts(
  cohort = cdm$medications,
  name = "medintersect"
)

cohortCount(cdm$medintersect)

## ----include=FALSE, warning=FALSE---------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = eunomiaDir())
cdm <- CDMConnector::cdmFromCon(con, cdmSchema = "main", 
                    writeSchema = "main", writePrefix = "my_study_")
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

## -----------------------------------------------------------------------------
cdm$medintersect <- CohortConstructor::intersectCohorts(
  cohort = cdm$medications,
  gap = 365,
  name = "medintersect"
)

cohortCount(cdm$medintersect)

## -----------------------------------------------------------------------------
cdm$medunion <- CohortConstructor::unionCohorts(
  cohort = cdm$medications,
  name = "medunion"
)

cohortCount(cdm$medunion)

## ----include=FALSE, warning=FALSE---------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = eunomiaDir())
cdm <- cdmFromCon(con, cdmSchema = "main", 
                    writeSchema = c(prefix = "my_study_", schema = "main"))
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

## -----------------------------------------------------------------------------
cdm$medunion <- CohortConstructor::unionCohorts(
  cohort = cdm$medications,
  name = "medunion",
  keepOriginalCohorts = TRUE
)

cohortCount(cdm$medunion)

## ----include=FALSE, warning=FALSE---------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = eunomiaDir())
cdm <- cdmFromCon(con, cdmSchema = "main", 
                    writeSchema = c(prefix = "my_study_", schema = "main"))
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

## -----------------------------------------------------------------------------
cdm$medunion <- CohortConstructor::unionCohorts(
  cohort = cdm$medications,
  name = "medunion",
  gap = 365,
  keepOriginalCohorts = TRUE
)

cohortCount(cdm$medunion)

