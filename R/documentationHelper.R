# Argument descriptions repeated > 1:

#' Helper for consistent documentation of `cohort`.
#'
#' @param cohort A cohort table in a cdm reference.
#'
#' @name cohortDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of `cohortId`.
#'
#' @param cohortId Vector identifying which cohorts to include
#' (cohort_definition_id or cohort_name). Cohorts not included will be
#' removed from the cohort set.
#'
#' @name cohortIdSubsetDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of `cohortId`.
#'
#' @param cohortId Vector identifying which cohorts to modify
#' (cohort_definition_id or cohort_name). If NULL, all cohorts will be
#' used; otherwise, only the specified cohorts will be modified, and the
#' rest will remain unchanged.
#'
#' @name cohortIdModifyDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of `name`.
#'
#' @param name Name of the new cohort table created in the cdm object.
#'
#' @name nameDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of `conceptSet`.
#'
#' @param conceptSet A conceptSet, which can either be a codelist
#' or a conceptSetExpression.
#'
#' @name conceptSetDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of `cdm`.
#'
#' @param cdm A cdm reference.
#'
#' @name cdmDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of `gap`.
#'
#' @param gap Number of days between two subsequent cohort entries to be merged
#' in a single cohort record.
#'
#' @name gapDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of `dateColumns` and `returnReason`.
#'
#' @param dateColumns Character vector indicating date columns in the cohort
#' table to consider.
#' @param returnReason If TRUE it will return a column indicating which of the
#' `dateColumns` was used.
#'
#' @name columnDateDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of `window`.
#'
#' @param window A list of vectors specifying minimum and maximum days from
#' `indexDate` to consider events over.
#'
#' @name windowDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of arguments in `requireIntersect`
#' functions.
#'
#' @param indexDate Name of the column in the cohort that contains the date to
#' compute the intersection.
#' @param intersections A range indicating number of intersections for
#' criteria to be fulfilled. If a single number is passed, the number of
#' intersections must match this.
#' @param targetStartDate Start date of reference in cohort table.
#' @param targetEndDate End date of reference in cohort table. If NULL,
#' incidence of target event in the window will be considered as intersection,
#' otherwise prevalence of that event will be used as intersection (overlap
#' between cohort and event).
#' @param censorDate Whether to censor overlap events at a specific date or a
#' column date of the cohort.
#' @param targetCohortTable Name of the cohort that we want to check for
#' intersect.
#' @param targetCohortId Vector of cohort definition ids to include.
#' @param tableName Name of the table to check for intersect.
#'
#' @name requireIntersectDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of arguments in `requireDemographics`.
#'
#' @param ageRange A list of vectors specifying minimum and maximum age.
#' @param sex Can be "Both", "Male" or "Female".
#' @param minPriorObservation A minimum number of continuous prior observation
#' days in the database.
#' @param minFutureObservation A minimum number of continuous future observation
#' days in the database.
#' @param indexDate Variable in cohort that contains the date to compute the
#' demographics characteristics on which to restrict on.
#' @param requirementInteractions If TRUE, cohorts will be created for
#' all combinations of ageGroup, sex, and daysPriorObservation. If FALSE, only
#' the first value specified for the other factors will be used. Consequently,
#' order of values matters when requirementInteractions is FALSE.
#'
#' @name requireDemographicsDoc
#' @keywords internal
NULL

