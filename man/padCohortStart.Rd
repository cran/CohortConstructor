% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/padCohortStart.R
\name{padCohortStart}
\alias{padCohortStart}
\title{Add days to cohort start}
\usage{
padCohortStart(cohort, days, cohortId = NULL, name = tableName(cohort))
}
\arguments{
\item{cohort}{A cohort table in a cdm reference.}

\item{days}{Number of day to add to the cohort start date.}

\item{cohortId}{Vector identifying which cohorts to modify
(cohort_definition_id or cohort_name). If NULL, all cohorts will be
used; otherwise, only the specified cohorts will be modified, and the
rest will remain unchanged.}

\item{name}{Name of the new cohort table created in the cdm object.}
}
\value{
Cohort table
}
\description{
\code{padCohortStart()} Adds (or subtracts) a certain number of days to the cohort
start date. Note:
\itemize{
\item If the days added means that cohort start would be after cohort end then
the cohort entry will be dropped.
\item If subtracting day means that cohort start would be before observation
period start then the cohort entry will be dropped.
}
}
\examples{
\donttest{
library(CohortConstructor)
cdm <- mockCohortConstructor()
# add 10 days to each cohort entry
cdm$cohort1 |>
  padCohortStart(days = 10)
}
}
