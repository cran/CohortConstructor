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
cohortCount(cdm$medications)

## -----------------------------------------------------------------------------
cdm$gi_bleed <- conceptCohort(cdm = cdm,  
                              conceptSet = list("gi_bleed" = 192671),
                              name = "gi_bleed")

## -----------------------------------------------------------------------------
cdm$medications_gi_bleed <- cdm$medications  %>%
  requireCohortIntersect(intersections = c(1,Inf),
                         targetCohortTable = "gi_bleed", 
                         targetCohortId = 1,
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "medications_gi_bleed")

summary_attrition <- summariseCohortAttrition(cdm$medications_gi_bleed)
plotCohortAttrition(summary_attrition, cohortId = 1)

## -----------------------------------------------------------------------------
cdm$medications_no_gi_bleed <- cdm$medications %>%
  requireCohortIntersect(intersections = 0,
                         targetCohortTable = "gi_bleed", 
                         targetCohortId = 1,
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "medications_no_gi_bleed") 

summary_attrition <- summariseCohortAttrition(cdm$medications_no_gi_bleed)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

cdm$gi_bleed <- conceptCohort(cdm = cdm,  
                              conceptSet = list("gi_bleed" = 192671),
                              name = "gi_bleed")

## -----------------------------------------------------------------------------
cdm$medications_gi_bleed <- cdm$medications  %>%
  requireConceptIntersect(conceptSet = list("gi_bleed" = 192671), 
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "medications_gi_bleed")

summary_attrition <- summariseCohortAttrition(cdm$medications_gi_bleed)
plotCohortAttrition(summary_attrition, cohortId = 1)

## -----------------------------------------------------------------------------
cdm$medications_no_gi_bleed <- cdm$medications  %>%
  requireConceptIntersect(intersections = 0,
                         conceptSet = list("gi_bleed" = 192671), 
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "medications_no_gi_bleed")

summary_attrition <- summariseCohortAttrition(cdm$medications_no_gi_bleed)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

cdm$gi_bleed <- conceptCohort(cdm = cdm,  
                              conceptSet = list("gi_bleed" = 192671),
                              name = "gi_bleed")

## -----------------------------------------------------------------------------
cdm$medications_gi_bleed <- cdm$medications  %>%
  requireTableIntersect(tableName = "gi_bleed",
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "medications_gi_bleed")

summary_attrition <- summariseCohortAttrition(cdm$medications_gi_bleed)
plotCohortAttrition(summary_attrition, cohortId = 1)

## -----------------------------------------------------------------------------
cdm$medications_no_gi_bleed <- cdm$medications  %>%
  requireTableIntersect(tableName = "gi_bleed",
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "medications_no_gi_bleed",
                        intersections = 0)

summary_attrition <- summariseCohortAttrition(cdm$medications_no_gi_bleed)
plotCohortAttrition(summary_attrition, cohortId = 1)

## ----include = FALSE----------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = list("diclofenac" = 1124300,
                                                   "acetaminophen" = 1127433), 
                                 name = "medications")

cdm$gi_bleed <- conceptCohort(cdm = cdm,  
                              conceptSet = list("gi_bleed" = 192671),
                              name = "gi_bleed")

## -----------------------------------------------------------------------------
cdm$medications_deaths <- cdm$medications  %>%
  requireDeathFlag(window = c(0,Inf), 
                         name = "medications_deaths")

summary_attrition <- summariseCohortAttrition(cdm$medications_deaths)
plotCohortAttrition(summary_attrition, cohortId = 1)

## -----------------------------------------------------------------------------
cdm$medications_no_deaths <- cdm$medications  %>%
  requireDeathFlag(window = c(0,Inf), 
                   name = "medications_no_deaths",
                   negate = TRUE)

summary_attrition <- summariseCohortAttrition(cdm$medications_no_deaths)
plotCohortAttrition(summary_attrition, cohortId = 1)

