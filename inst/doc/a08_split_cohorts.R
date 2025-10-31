## ----include = FALSE----------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")

knitr::opts_chunk$set(
  collapse = TRUE, 
  warning = FALSE, 
  message = FALSE,
  comment = "#>",
  eval = NOT_CRAN
)

## -----------------------------------------------------------------------------
# library(omock)
# library(PatientProfiles)
# library(CohortConstructor)
# library(dplyr, warn.conflicts = FALSE)
# library(clock)

## -----------------------------------------------------------------------------
# cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

## -----------------------------------------------------------------------------
# cdm$medications <- conceptCohort(cdm = cdm,
#                                  conceptSet = list("diclofenac" = 1124300L,
#                                                    "acetaminophen" = 1127433L),
#                                  name = "medications")
# cohortCount(cdm$medications)
# settings(cdm$medications)

## -----------------------------------------------------------------------------
# cdm$medications_female <- cdm$medications |>
#   requireSex(sex = "Female", name = "medications_female") |>
#   renameCohort(
#     newCohortName = "{cohort_name}_female"
#   )
# cdm$medications_male <- cdm$medications |>
#   requireSex(sex = "Male", name = "medications_male") |>
#   renameCohort(
#     newCohortName = "{cohort_name}_male"
#   )
# cdm <- bind(cdm$medications_female, cdm$medications_male, name = "medications_sex")
# cohortCount(cdm$medications_sex)
# settings(cdm$medications_sex)

## -----------------------------------------------------------------------------
# cdm$medications <- cdm$medications |>
#   addSex()
# cdm$medications

## -----------------------------------------------------------------------------
# cdm$medications_sex_2 <- cdm$medications |>
#   stratifyCohorts(strata = "sex", name = "medications_sex_2")
# cohortCount(cdm$medications_sex_2)
# settings(cdm$medications_sex_2)

## ----warning=FALSE------------------------------------------------------------
# cdm$stratified <- cdm$medications |>
#   addAge(ageGroup = list("child" = c(0,17), "18_to_65" = c(18,64), "65_and_over" = c(65, Inf))) |>
#   addSex() |>
#   mutate(year = get_year(cohort_start_date)) |>
#   stratifyCohorts(strata = list(c("sex", "age_group"), "year"), name = "stratified")
# 
# cohortCount(cdm$stratified)
# settings(cdm$stratified)

## ----echo=FALSE---------------------------------------------------------------
# library(ggplot2)
# x <- tibble(
#   time = as.Date(c("2010-05-01", "2012-06-12", "2010-05-01", "2010-12-31", "2011-01-01", "2011-12-31", "2012-01-01", "2012-06-12")),
#   y = c(rep(1, 2), rep(0.8, 2), rep(0.78, 2), rep(0.76, 2)),
#   colour = c(rep("1", 2), rep("2", 6)),
#   group = c(1L, 1L, 2L, 2L, 3L, 3L, 4L, 4L)
# )
# ggplot(data = x, mapping = aes(x = time, y = y, colour = colour, group = group)) +
#   geom_line() +
#   geom_point() +
#   scale_y_continuous(limits = c(0.56, 1.2), breaks = NULL, labels = NULL) +
#   theme_bw() +
#   theme(
#     axis.title.y = element_blank(),
#     axis.text.y = element_blank(),
#     axis.ticks.y = element_blank(),
#     legend.position = "none"
#   )

## -----------------------------------------------------------------------------
# cdm$medications_year <- cdm$medications |>
#   yearCohorts(years = c(1990:1993), name = "medications_year")
# settings(cdm$medications_year)
# cohortCount(cdm$medications_year)

## -----------------------------------------------------------------------------
# cdm$medications |>
#   filter(subject_id == 4383)

## -----------------------------------------------------------------------------
# cdm$medications_year |>
#   filter(subject_id == 4383)

