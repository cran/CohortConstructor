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
library(CDMConnector)
library(CohortConstructor)
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = eunomia_dir())
cdm <- cdm_from_con(con, cdm_schema = "main", 
                    write_schema = c(prefix = "my_study_", schema = "main"))

## -----------------------------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$gi_bleed <- conceptCohort(cdm = cdm,  
                              conceptSet = list("gi_bleed" = 192671),
                              name = "gi_bleed")

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireIsFirstEntry(indexDate = "cohort_start_date")

cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireDemographics(indexDate = "cohort_start_date", 
                      ageRange = list(c(18, 85)),
                      sex = "Female", 
                      minPriorObservation = 30)

## -----------------------------------------------------------------------------
cohort_attrition(cdm$medications) %>% 
  dplyr::filter(reason == "Demographic requirements") %>% 
  dplyr::glimpse()

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications %>% 
  requireInDateRange(indexDate = "cohort_start_date", 
                     dateRange = as.Date(c("2000-01-01", "2015-01-01")))

## -----------------------------------------------------------------------------
cohort_attrition(cdm$medications) %>% 
  dplyr::filter(reason == "cohort_start_date between 2000-01-01 and 2015-01-01") %>% 
  dplyr::glimpse()

## -----------------------------------------------------------------------------
cdm$medications_gi_bleed <- cdm$medications  %>%
  requireCohortIntersect(intersections = c(1,Inf),
                         targetCohortTable = "gi_bleed", 
                         targetCohortId = 1,
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "medications_gi_bleed")
cohort_count(cdm$medications_gi_bleed)

## -----------------------------------------------------------------------------
cdm$medications_no_gi_bleed <- cdm$medications %>%
  requireCohortIntersect(intersections = 0,
                         targetCohortTable = "gi_bleed", 
                         targetCohortId = 1,
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "medications_no_gi_bleed") 
cohort_count(cdm$medications_no_gi_bleed)

