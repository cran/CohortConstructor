## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
eval = TRUE, 
warning = FALSE, 
message = FALSE,
comment = "#>"
)

## -----------------------------------------------------------------------------
library(omock)
library(CodelistGenerator)
library(PatientProfiles)
library(CohortConstructor)
library(dplyr)
library(CDMConnector)
library(duckdb)

cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

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
                           useRecordsBeforeObservation = TRUE, 
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
cdm <- mockVocabularyTables(concept = tibble(
  concept_id = c(4326744, 4298393, 45770407, 8876, 4124457, 1990036),
  concept_name = c("Blood pressure", "Systemic blood pressure",
                   "Baseline blood pressure", "millimeter mercury column",
                   "Normal range", "Overweight"),
  domain_id = "Measurement",
  vocabulary_id = c("SNOMED", "SNOMED", "SNOMED", "UCUM", "SNOMED", "SNOMED"),
  standard_concept = "S",
  concept_class_id = c("Observable Entity", "Observable Entity",
                       "Observable Entity", "Unit", "Qualifier Value", "Qualifier Value"),
  concept_code = NA_character_,
  valid_start_date = as.Date(NA_character_),
  valid_end_date = as.Date(NA_character_),
  invalid_reason = NA_character_
)) |>
  mockCdmFromTables(tables = list(
    measurement = tibble(
      measurement_id = 1:5L,
      person_id = c(1L, 1L, 2L, 3L, 2L),
      measurement_concept_id = c(4326744L, 4298393L, 4298393L, 4245997L, 4245997L),
      measurement_date = as.Date(c("2000-07-01", "2000-12-11", "2002-09-08", "2015-02-19", "2002-09-08")),
      measurement_type_concept_id = 0L,
      value_as_number = c(100, 125, NA, NA, NA),
      value_as_concept_id = c(0L, 0L, 0L, 4124457L, 4328749L),
      unit_concept_id = c(8876L, 8876L, 0L, 0L, 0L)
   )
 ))

# copy the datatbase to duckdb
src <- dbSource(con = dbConnect(drv = duckdb()), writeSchema = "main")
cdm <- insertCdmTo(cdm = cdm, to = src)

## -----------------------------------------------------------------------------
cdm$cohort <- measurementCohort(
  cdm = cdm,
  name = "cohort",
  conceptSet = list("bmi" = c(4245997)),
  valueAsConcept = list("bmi_normal" = c(4069590), "bmi_overweight" = c(1990036)),
  valueAsNumber = list("bmi_normal" = list("9531" = c(18, 25)), "bmi_overweight" = list("9531" = c(26, 30)))
)

attrition(cdm$cohort)
settings(cdm$cohort)
cdm$cohort

## -----------------------------------------------------------------------------
cdm$cohort <- measurementCohort(
  cdm = cdm,
  name = "cohort",
  conceptSet = list("bmi" = c(4245997)),
  valueAsConcept = list("bmi_normal" = c(4069590)),
  valueAsNumber = list("bmi_normal" = list("9531" = c(18, 25))),
  useRecordsBeforeObservation = TRUE
)

attrition(cdm$cohort)
settings(cdm$cohort)
cdm$cohort

## ----include=FALSE------------------------------------------------------------
cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

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

