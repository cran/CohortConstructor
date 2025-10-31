## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = TRUE, 
  message = FALSE, 
  warning = FALSE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(omock)
library(CodelistGenerator)
library(CohortConstructor)
library(CohortCharacteristics)
library(ggplot2)
library(dplyr)

## -----------------------------------------------------------------------------
cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

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
                                   exit = "event_end_date",
                                   name = "acetaminophen") |> 
  requireDuration(c(30, Inf))

summary_attrition <- summariseCohortAttrition(cdm$acetaminophen)
plotCohortAttrition(summary_attrition)

## -----------------------------------------------------------------------------
cdm$acetaminophen <- conceptCohort(cdm = cdm, 
                                   conceptSet = acetaminophen_codes, 
                                   exit = "event_end_date",
                                   name = "acetaminophen")
cdm$acetaminophen <- cdm$acetaminophen |> 
  requireIsEntry(entryRange = c(1,2))

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
cdm$acetaminophen <- conceptCohort(cdm = cdm, 
                                 conceptSet = acetaminophen_codes, 
                                 name = "acetaminophen")

## -----------------------------------------------------------------------------
cdm$acetaminophen_one_night <- cdm$acetaminophen |> 
  requireDuration(c(2, Inf), 
                  name = "acetaminophen_one_night") |> 
  renameCohort("acetaminophen_one_night")

cdm <- bind(cdm$acetaminophen,
            cdm$acetaminophen_one_night, 
            name = "both_cohorts")

## -----------------------------------------------------------------------------
summary_attrition <- summariseCohortAttrition(cdm$both_cohorts)
plotCohortAttrition(summary_attrition)

## ----warning=FALSE------------------------------------------------------------
summary_characteristics <- summariseCharacteristics(cdm$both_cohorts)
tableCharacteristics(summary_characteristics |>
                       filter(variable_name %in% c("Number subjects", "Days in cohort")))

## -----------------------------------------------------------------------------
cdm$acetaminophen_1 <- conceptCohort(cdm = cdm, 
                                 conceptSet = acetaminophen_codes, 
                                 name = "acetaminophen_1") |> 
  requireIsFirstEntry() |>
  requireInDateRange(dateRange = as.Date(c("2010-01-01", "2016-01-01"))) |> 
  renameCohort("entry_before_date")

cdm$acetaminophen_2 <- conceptCohort(cdm = cdm, 
                                 conceptSet = acetaminophen_codes, 
                                 name = "acetaminophen_2") |>
  requireInDateRange(dateRange = as.Date(c("2010-01-01", "2016-01-01"))) |> 
  requireIsFirstEntry("date_before_entry")

## -----------------------------------------------------------------------------
cdm <- bind(cdm$acetaminophen_1,
            cdm$acetaminophen_2, 
            name = "both_cohorts")
summary_attrition <- summariseCohortAttrition(cdm$both_cohorts)

## -----------------------------------------------------------------------------
plotCohortAttrition(summary_attrition)

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

