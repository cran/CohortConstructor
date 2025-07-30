## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(CodelistGenerator)
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
cdm <- CDMConnector::cdmFromCon(con, cdmSchema = "main", 
                    writeSchema = "main", writePrefix = "my_study_")

## -----------------------------------------------------------------------------
fracture_codes <- getCandidateCodes(cdm, "fracture")
fracture_codes <- list("fracture" = fracture_codes$concept_id)
cdm$fracture <- conceptCohort(cdm = cdm, 
                                 conceptSet = fracture_codes, 
                                 name = "fracture")

summary_attrition <- summariseCohortAttrition(cdm$fracture)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$fracture <- cdm$fracture |> 
  requireAge(indexDate = "cohort_start_date",
             ageRange = list(c(18, 100)))

summary_attrition <- summariseCohortAttrition(cdm$fracture)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$fracture <- cdm$fracture |> 
  requireSex(sex = "Female")

summary_attrition <- summariseCohortAttrition(cdm$fracture)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$fracture <- cdm$fracture |> 
  requirePriorObservation(indexDate = "cohort_start_date",
                          minPriorObservation = 365)

summary_attrition <- summariseCohortAttrition(cdm$fracture)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$fracture <- conceptCohort(cdm = cdm, 
                                 conceptSet = fracture_codes, 
                                 name = "fracture") |> 
  requireDemographics(indexDate = "cohort_start_date",
                      ageRange = c(18,100),
                      sex = "Female",
                      minPriorObservation = 365, 
                      minFutureObservation = 30)

summary_attrition <- summariseCohortAttrition(cdm$fracture)
plotCohortAttrition(summary_attrition)

