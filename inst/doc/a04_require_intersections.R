## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(CodelistGenerator)
library(CohortConstructor)
library(CohortCharacteristics)
library(visOmopResults)
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
warfarin_codes <- getDrugIngredientCodes(cdm, "warfarin")
cdm$warfarin <- conceptCohort(cdm = cdm, 
                                 conceptSet = warfarin_codes, 
                                 name = "warfarin")
cohortCount(cdm$warfarin)

## -----------------------------------------------------------------------------
cdm$gi_bleed <- conceptCohort(cdm = cdm,  
                              conceptSet = list("gi_bleed" = 192671L),
                              name = "gi_bleed")

## -----------------------------------------------------------------------------
cdm$warfarin_gi_bleed <- cdm$warfarin  |>
  requireCohortIntersect(intersections = c(1,Inf),
                         targetCohortTable = "gi_bleed", 
                         targetCohortId = 1,
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "warfarin_gi_bleed")

summary_attrition <- summariseCohortAttrition(cdm$warfarin_gi_bleed)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$warfarin_no_gi_bleed <- cdm$warfarin |>
  requireCohortIntersect(intersections = 0,
                         targetCohortTable = "gi_bleed", 
                         targetCohortId = 1,
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "warfarin_no_gi_bleed") 

summary_attrition <- summariseCohortAttrition(cdm$warfarin_no_gi_bleed)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$warfarin_gi_bleed <- cdm$warfarin  |>
  requireConceptIntersect(conceptSet = list("gi_bleed" = 192671), 
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "warfarin_gi_bleed")

summary_attrition <- summariseCohortAttrition(cdm$warfarin_gi_bleed)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$warfarin_no_gi_bleed <- cdm$warfarin  |>
  requireConceptIntersect(intersections = 0,
                         conceptSet = list("gi_bleed" = 192671), 
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, 0), 
                         name = "warfarin_no_gi_bleed")

summary_attrition <- summariseCohortAttrition(cdm$warfarin_no_gi_bleed)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$warfarin_visit <- cdm$warfarin  |>
  requireTableIntersect(tableName = "visit_occurrence",
                         indexDate = "cohort_start_date", 
                         window = c(-Inf, -1), 
                         name = "warfarin_visit")

summary_attrition <- summariseCohortAttrition(cdm$warfarin_visit)
plotCohortAttrition(summary_attrition)

