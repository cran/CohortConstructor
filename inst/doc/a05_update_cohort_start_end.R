## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(CohortConstructor)
library(CohortCharacteristics)
library(PatientProfiles)
library(CDMConnector)

if (Sys.getenv("EUNOMIA_DATA_FOLDER") == ""){
Sys.setenv("EUNOMIA_DATA_FOLDER" = file.path(tempdir(), "eunomia"))}
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))){ dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
downloadEunomiaData()  
}

con <- DBI::dbConnect(duckdb::duckdb(), dbdir = CDMConnector::eunomiaDir())
cdm <- CDMConnector::cdmFromCon(con, cdmSchema = "main", 
                    writeSchema = "main", writePrefix = "my_study_")

cdm$cohort <- demographicsCohort(cdm = cdm, name = "cohort", sex = "Female")

## -----------------------------------------------------------------------------
cdm$cohort_observation_end <- cdm$cohort |> 
  exitAtObservationEnd(name = "cohort_observation_end")

## -----------------------------------------------------------------------------
cdm$cohort_death <- cdm$cohort |> 
  exitAtDeath(requireDeath = TRUE, name = "cohort_death")

## -----------------------------------------------------------------------------
# create cohort with of drugs diclofenac and acetaminophen 
cdm$medications <- conceptCohort(
  cdm = cdm, name = "medications",
  conceptSet = list("diclofenac" = 1124300, "acetaminophen" = 1127433)
)

# add date first ocurrence of these drugs from index date
cdm$cohort_dates <- cdm$cohort |> 
  addCohortIntersectDate(
    targetCohortTable = "medications", 
    nameStyle = "{cohort_name}",
    name = "cohort_dates"
    ) 

# set cohort start at the first ocurrence of one of the drugs, or the end date
cdm$cohort_entry_first <- cdm$cohort_dates |>
  entryAtFirstDate(
    dateColumns = c("diclofenac", "acetaminophen", "cohort_end_date"), 
    name = "cohort_entry_first"
  )
cdm$cohort_entry_first 

## -----------------------------------------------------------------------------
cdm$cohort_entry_last <- cdm$cohort_dates |>
  entryAtLastDate(
    dateColumns = c("diclofenac", "acetaminophen", "cohort_end_date"), 
    keepDateColumns = FALSE,
    name = "cohort_entry_last"
  )

cdm$cohort_entry_last

## -----------------------------------------------------------------------------
cdm$cohort_exit_first <- cdm$cohort_dates |>
  addFutureObservation(futureObservationType = "date", name = "cohort_exit_first") |>
  exitAtFirstDate(
    dateColumns = c("future_observation", "acetaminophen", "diclofenac"),
    keepDateColumns = FALSE
  )

cdm$cohort_exit_first 

## -----------------------------------------------------------------------------
cdm$cohort_exit_last <- cdm$cohort_dates |> 
  exitAtLastDate(
    dateColumns = c("cohort_end_date", "acetaminophen", "diclofenac"),
    returnReason = FALSE,
    keepDateColumns = FALSE,
    name = "cohort_exit_last"
  )
cdm$cohort_exit_last

## -----------------------------------------------------------------------------
cdm$cohort_trim <- cdm$cohort |>
  trimDemographics(ageRange = c(18, 65), name = "cohort_trim")

## -----------------------------------------------------------------------------
# Trim cohort dates to be within the year 2000
cdm$cohort_trim <- cdm$cohort_trim |> 
  trimToDateRange(dateRange = as.Date(c("2015-01-01", NA)))

## -----------------------------------------------------------------------------
# Substract 50 days to cohort start
cdm$cohort <- cdm$cohort |> padCohortStart(days = -50, collapse = FALSE)

## -----------------------------------------------------------------------------
cdm$cohort_pad <- cdm$cohort |> 
  padCohortEnd(days = 1000, padObservation = FALSE, name = "cohort_pad")

## -----------------------------------------------------------------------------
cdm$cohort <- cdm$cohort %>% 
  dplyr::mutate(days_to_add = !!CDMConnector::datediff("cohort_start_date", "cohort_end_date")) |>
  padCohortEnd(days = "days_to_add", padObservation = FALSE)

## -----------------------------------------------------------------------------
cdm$cohort <- cdm$cohort |> 
  padCohortDate(days = 365, cohortDate = "cohort_end_date", indexDate = "cohort_start_date")

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications |> 
  padCohortDate(days = 10, cohortId = "acetaminophen") |> 
  padCohortDate(days = 20, cohortId = "diclofenac")

