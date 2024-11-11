## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
eval = TRUE, 
warning = FALSE, 
message = FALSE,
comment = "#>"
)

library(CDMConnector)
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == ""){
Sys.setenv("EUNOMIA_DATA_FOLDER" = file.path(tempdir(), "eunomia"))}
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))){ dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
downloadEunomiaData()  
}

## -----------------------------------------------------------------------------
library(CDMConnector)
library(CodelistGenerator)
library(PatientProfiles)
library(CohortConstructor)
library(dplyr)

con <- DBI::dbConnect(duckdb::duckdb(), 
                      dbdir = eunomia_dir())
cdm <- cdm_from_con(con, cdm_schema = "main", 
                    write_schema = c(prefix = "my_study_", schema = "main"))

## -----------------------------------------------------------------------------
drug_codes <- getDrugIngredientCodes(cdm, 
                                     name = c("acetaminophen",
                                              "amoxicillin", 
                                              "diclofenac", 
                                              "simvastatin",
                                              "warfarin"))

drug_codes

## -----------------------------------------------------------------------------
cdm$drugs <- conceptCohort(cdm, 
                           conceptSet = drug_codes,
                           exit = "event_end_date",
                           name = "drugs")

settings(cdm$drugs)
cohortCount(cdm$drugs)
attrition(cdm$drugs)

## -----------------------------------------------------------------------------
cdm$working_age_cohort <- demographicsCohort(cdm = cdm, 
                                             ageRange = c(18, 65), 
                                             name = "working_age_cohort")

