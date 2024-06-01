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
cdm$working_age_cohort <- demographicsCohort(cdm = cdm, 
                                             ageRange = c(18, 65), 
                                             name = "working_age_cohort")

settings(cdm$working_age_cohort)
cohortCount(cdm$working_age_cohort)
attrition(cdm$working_age_cohort)

## -----------------------------------------------------------------------------
cdm$working_age_cohort |> 
  addAge(indexDate = "cohort_start_date") |> 
  summarise(min_start_age = min(age), 
            median_start_age = median(age), 
            max_start_age = max(age))

cdm$working_age_cohort |> 
  addAge(indexDate = "cohort_end_date") |> 
  summarise(min_start_age = min(age), 
            median_start_age = median(age), 
            max_start_age = max(age))

## -----------------------------------------------------------------------------
drug_codes <- getDrugIngredientCodes(cdm, 
                                     name = c("diclofenac", 
                                              "acetaminophen"))

drug_codes

## -----------------------------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = drug_codes, 
                                 name = "medications")

settings(cdm$medications)
cohortCount(cdm$medications)

