## ----include = FALSE----------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")

knitr::opts_chunk$set(
  collapse = TRUE, 
  warning = FALSE, 
  message = FALSE,
  comment = "#>",
  eval = NOT_CRAN
)

library(CDMConnector)
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == ""){
Sys.setenv("EUNOMIA_DATA_FOLDER" = file.path(tempdir(), "eunomia"))}
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))){ dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
downloadEunomiaData()  
}


## -----------------------------------------------------------------------------
# library(CDMConnector)
# library(CodelistGenerator)
# library(PatientProfiles)
# library(CohortConstructor)
# library(dplyr)
# 
# con <- DBI::dbConnect(duckdb::duckdb(),
#                       dbdir = eunomiaDir())
# cdm <- cdmFromCon(con, cdmSchema = "main", writeSchema = "main",
#                   writePrefix = "my_study_")
# drug_codes <- getDrugIngredientCodes(cdm,
#                                      name = c("acetaminophen",
#                                               "amoxicillin",
#                                               "diclofenac",
#                                               "simvastatin",
#                                               "warfarin"))

## -----------------------------------------------------------------------------
# dir_sql <- file.path(tempdir(), "sql_folder")
# dir.create(dir_sql)
# options("omopgenerics.log_sql_path" = dir_sql)
# 
# cdm$drugs <- conceptCohort(cdm,
#                            conceptSet = drug_codes,
#                            exit = "event_end_date",
#                            name = "drugs")
# 
# # print sql in order they were saved
# files <- file.info(list.files(dir_sql, full.names = TRUE))
# sorted_files <- rownames(files[order(files$ctime),])
# for(i in seq_along(sorted_files)) {
#   cat(paste0("### ", sorted_files[i], "\n\n"))
#   sql_with_quotes <- paste0('"', paste(readLines(sorted_files[i]), collapse = '\n'), '"')
#   cat(sql_with_quotes, "\n```\n\n")
# }

## -----------------------------------------------------------------------------
# dir_explain <- file.path(tempdir(), "explain_folder")
# dir.create(dir_explain)
# options("omopgenerics.log_sql_explain_path" = dir_explain)
# 
# cdm$drugs <- cdm$drugs |>
#   requireIsFirstEntry()
# 
# files <- list.files(dir_explain, full.names = TRUE)
# file_names <- list.files(dir_explain, full.names = FALSE)
# 
# for(i in seq_along(files)) {
#   cat(paste0("### ", file_names[i], "\n\n"))
#   sql_with_quotes <- paste0('"', paste(readLines(files[i]), collapse = '\n'), '"')
#   cat(sql_with_quotes, "\n```\n\n")
# }

