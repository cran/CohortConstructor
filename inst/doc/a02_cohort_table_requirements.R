## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = TRUE, 
  message = FALSE, 
  warning = FALSE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(CodelistGenerator)
library(CohortConstructor)
library(CohortCharacteristics)
library(ggplot2)
library(dplyr)

## ----include = FALSE----------------------------------------------------------
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == ""){
  Sys.setenv("EUNOMIA_DATA_FOLDER" = file.path(tempdir(), "eunomia"))}
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))){ dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
  CDMConnector::downloadEunomiaData()  
}

## -----------------------------------------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = CDMConnector::eunomia_dir())
cdm <- CDMConnector::cdm_from_con(con, cdm_schema = "main", 
                    write_schema = c(prefix = "my_study_", schema = "main"))

## -----------------------------------------------------------------------------
acetaminophen_codes <- getDrugIngredientCodes(cdm, 
                                              name = "acetaminophen", 
                                              nameStyle = "{concept_name}")
cdm$acetaminophen <- conceptCohort(cdm = cdm, 
                                   conceptSet = acetaminophen_codes, 
                                   exit = "event_end_date",
                                   name = "acetaminophen")

## -----------------------------------------------------------------------------
summary_attrition <- summariseCohortAttrition(cdm$acetaminophen)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$acetaminophen <- cdm$acetaminophen |> 
  requireIsFirstEntry()

summary_attrition <- summariseCohortAttrition(cdm$acetaminophen)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$acetaminophen <- conceptCohort(cdm = cdm, 
                                 conceptSet = acetaminophen_codes, 
                                 name = "acetaminophen")

## -----------------------------------------------------------------------------
cdm$acetaminophen <- cdm$acetaminophen |> 
  requireInDateRange(dateRange = as.Date(c("2010-01-01", "2015-01-01")))

summary_attrition <- summariseCohortAttrition(cdm$acetaminophen)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$acetaminophen_1 <- conceptCohort(cdm = cdm, 
                                 conceptSet = acetaminophen_codes, 
                                 name = "acetaminophen_1") |> 
  requireIsFirstEntry() |>
  requireInDateRange(dateRange = as.Date(c("2010-01-01", "2016-01-01")))

cdm$acetaminophen_2 <- conceptCohort(cdm = cdm, 
                                 conceptSet = acetaminophen_codes, 
                                 name = "acetaminophen_2") |>
  requireInDateRange(dateRange = as.Date(c("2010-01-01", "2016-01-01"))) |> 
  requireIsFirstEntry()

## -----------------------------------------------------------------------------
summary_attrition_1 <- summariseCohortAttrition(cdm$acetaminophen_1)
summary_attrition_2 <- summariseCohortAttrition(cdm$acetaminophen_2)

## -----------------------------------------------------------------------------
plotCohortAttrition(summary_attrition_1)

## -----------------------------------------------------------------------------
plotCohortAttrition(summary_attrition_2)

## -----------------------------------------------------------------------------
medication_codes <- getDrugIngredientCodes(cdm = cdm, nameStyle = "{concept_name}")
medication_codes

## -----------------------------------------------------------------------------
cdm$medications <- conceptCohort(cdm = cdm, 
                                 conceptSet = medication_codes,
                                 name = "medications")


cohortCount(cdm$medications) |> 
  filter(number_subjects > 0) |> 
  ggplot() +
  geom_histogram(aes(number_subjects),
                 colour = "black",
                 binwidth = 25) +  
  xlab("Number of subjects") +
  theme_bw()

## -----------------------------------------------------------------------------
cdm$medications <- cdm$medications |> 
  requireMinCohortCount(minCohortCount = 500)

cohortCount(cdm$medications) |> 
  filter(number_subjects > 0) |> 
  ggplot() +
  geom_histogram(aes(number_subjects),
                 colour = "black",
                 binwidth = 25) + 
  xlim(0, NA) + 
  xlab("Number of subjects") +
  theme_bw()

