## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
eval = TRUE, 
warning = FALSE, 
message = FALSE,
comment = "#>"
)

library(CDMConnector)
requireEunomia()

## -----------------------------------------------------------------------------
library(CDMConnector)
library(CodelistGenerator)
library(PatientProfiles)
library(CohortConstructor)
library(dplyr)

con <- DBI::dbConnect(duckdb::duckdb(), 
                      dbdir = eunomiaDir())
cdm <- cdmFromCon(con, cdmSchema = "main", writeSchema = "main", 
                  writePrefix = "my_study_")

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

bronchitis_codes <- list(bronchitis = c(260139, 256451, 4232302))

cdm$bronchitis <- conceptCohort(cdm, 
                           conceptSet = bronchitis_codes,
                           exit = "event_start_date",
                           name = "bronchitis",
                           table = "condition_occurrence", 
                           subsetCohort = "drugs", 
                           subsetCohortId = 1
                           )


cohortCount(cdm$bronchitis)
attrition(cdm$bronchitis)


## -----------------------------------------------------------------------------
cdm$drugs_merge <- conceptCohort(cdm, 
                           conceptSet = drug_codes,
                           overlap = "merge",
                           name = "drugs_merge")

cdm$drugs_merge |>
  attrition()


## -----------------------------------------------------------------------------
cdm$drugs_extend <- conceptCohort(cdm, 
                           conceptSet = drug_codes,
                           overlap = "extend",
                           name = "drugs_extend")

cdm$drugs_extend |>
  attrition()

## -----------------------------------------------------------------------------

cdm$celecoxib <- conceptCohort(cdm, 
                           conceptSet = list(celecoxib = 44923712),
                           name = "celecoxib", 
                           inObservation = FALSE, 
                           useSourceFields = TRUE)
cdm$celecoxib |>
  glimpse()

## -----------------------------------------------------------------------------
cdm$working_age_cohort <- demographicsCohort(cdm = cdm, 
                                             ageRange = c(18, 65), 
                                             name = "working_age_cohort")

settings(cdm$working_age_cohort)
cohortCount(cdm$working_age_cohort)
attrition(cdm$working_age_cohort)

## -----------------------------------------------------------------------------
cdm$female_working_age_cohort <- demographicsCohort(cdm = cdm, 
                                             ageRange = c(18, 65),
                                             sex = "Female",
                                             name = "female_working_age_cohort")

settings(cdm$female_working_age_cohort)
cohortCount(cdm$female_working_age_cohort)
attrition(cdm$female_working_age_cohort)

## -----------------------------------------------------------------------------
cdm$age_sex_cohorts <- demographicsCohort(cdm = cdm, 
                                             ageRange = list(c(0, 17), c(18, 65), c(66,120)),
                                             sex = c("Female", "Male"),
                                             name = "age_sex_cohorts")

settings(cdm$age_sex_cohorts)
cohortCount(cdm$age_sex_cohorts)
attrition(cdm$age_sex_cohorts)


## -----------------------------------------------------------------------------
cdm$working_age_cohort_0_365 <- demographicsCohort(cdm = cdm, 
                                             ageRange = c(18, 65), 
                                             name = "working_age_cohort_0_365",
                                             minPriorObservation = c(0,365))

settings(cdm$working_age_cohort_0_365)
cohortCount(cdm$working_age_cohort_0_365)
attrition(cdm$working_age_cohort_0_365)


## ----include = FALSE----------------------------------------------------------
cdm <- mockCohortConstructor(con = NULL)
cdm$concept <- cdm$concept |>
  dplyr::union_all(
    dplyr::tibble(
      concept_id = c(4245997, 9531, 4069590),
      concept_name = c("Body mass index", "kilogram per square meter", "Normal"),
      domain_id = "Measurement",
      vocabulary_id = c("SNOMED", "UCUM", "SNOMED"),
      standard_concept = "S",
      concept_class_id = c("Observable Entity", "Unit", "Qualifier Value"),
      concept_code = NA,
      valid_start_date = NA,
      valid_end_date = NA,
      invalid_reason = NA
    )
  )
cdm$measurement <- dplyr::tibble(
  measurement_id = 1:6,
  person_id = c(1, 1, 3, 1, 3, 2),
  measurement_concept_id = c(4245997, 4245997, 4245997, 4245997, 4245997, 4245997),
  measurement_date = as.Date(c("2009-07-01", "2000-12-11", "1999-09-08",
                                "2015-02-19", "2016-08-22", "1965-03-10")),
  measurement_type_concept_id = NA,
  value_as_number = c(18, 36, 0, 29, 0, 25),
  value_as_concept_id = c(0, 0, 4069590, 4069590, 4069590, 0),
  unit_concept_id = c(9531, 9531, 0, 9531, 0, 9531)
)
cdm <- CDMConnector::copyCdmTo(
  con = DBI::dbConnect(duckdb::duckdb()),
  cdm = cdm, schema = "main")

## -----------------------------------------------------------------------------
cdm$cohort <- measurementCohort(
  cdm = cdm,
  name = "cohort",
  conceptSet = list("bmi_normal" = c(4245997)),
  valueAsConcept = c(4069590),
  valueAsNumber = list("9531" = c(18, 25))
)

attrition(cdm$cohort)
settings(cdm$cohort)
cdm$cohort

## -----------------------------------------------------------------------------
cdm$cohort <- measurementCohort(
  cdm = cdm,
  name = "cohort",
  conceptSet = list("bmi_normal" = c(4245997)),
  valueAsConcept = c(4069590),
  valueAsNumber = list("9531" = c(18, 25)),
  inObservation = FALSE
)

attrition(cdm$cohort)
settings(cdm$cohort)
cdm$cohort

## ----include=FALSE------------------------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), 
                      dbdir = eunomiaDir())
cdm <- cdmFromCon(con, cdmSchema = "main", writeSchema = "main", 
                  writePrefix = "my_study_")
cdm$drugs <- conceptCohort(cdm, 
                           conceptSet = drug_codes,
                           exit = "event_end_date",
                           name = "drugs")

## -----------------------------------------------------------------------------
cdm$death_cohort <- deathCohort(cdm = cdm,
                                name = "death_cohort")

## -----------------------------------------------------------------------------
cdm$death_drugs <- deathCohort(cdm = cdm,
                               name = "death_drugs",
                               subsetCohort = "drugs")

