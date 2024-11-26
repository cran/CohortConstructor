## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
eval = TRUE, 
warning = FALSE, 
message = FALSE,
comment = "#>",
echo = FALSE
)

## -----------------------------------------------------------------------------
# Packages
library(visOmopResults)
library(omopgenerics)
library(ggplot2)
library(CohortCharacteristics)
library(stringr)
library(dplyr)
library(tidyr)
library(gt)
library(scales)
library(CohortConstructor)
library(gt)

niceOverlapLabels <- function(labels) {
  new_labels <- gsub("_", " ", gsub(" and.*|cc_", "", labels))
  return(
    tibble("Cohort name" = new_labels) |>
      mutate(
        "Cohort name" = str_to_sentence(gsub("_", " ", gsub("cc_|atlas_", "", new_labels))),
        "Cohort name" = case_when(
          grepl("Asthma", .data[["Cohort name"]]) ~ "Asthma without COPD",
          grepl("Covid", .data[["Cohort name"]]) ~ gsub("Covid|Covid", "COVID-19", `Cohort name`),
          grepl("eutropenia", .data[["Cohort name"]]) ~ "Acquired neutropenia or unspecified leukopenia",
          grepl("Hosp", .data[["Cohort name"]]) ~ "Inpatient hospitalisation",
          grepl("First", .data[["Cohort name"]]) ~ "First major depression",
          grepl("fluoro", .data[["Cohort name"]]) ~ "New fluoroquinolone users",
          grepl("Beta", .data[["Cohort name"]]) ~ "New users of beta blockers nested in essential hypertension",
          .default = .data[["Cohort name"]]
        ),
        "Cohort name" = if_else(
          grepl("COVID", .data[["Cohort name"]]),
          gsub(" female", ": female", gsub(" male", ": male", .data[["Cohort name"]])),
          .data[["Cohort name"]]
        ),
        "Cohort name" = if_else(
          grepl(" to ", .data[["Cohort name"]]),
          gsub("male ", "male, ", .data[["Cohort name"]]),
          .data[["Cohort name"]]
        )
      )
  )
}

## -----------------------------------------------------------------------------
benchmarkData$omop |>
  visOmopResults::formatTable() |>
  tab_style(style = list(cell_fill(color = "#e1e1e1"), cell_text(weight = "bold")),
            locations = cells_column_labels()) |>
  tab_style(style = list(cell_text(weight = "bold")),
            locations = cells_body(columns = 1))

## -----------------------------------------------------------------------------
benchmarkData$details |>
  visOmopResults::formatTable(groupColumn = "cdm_name") |>
  tab_style(style = list(cell_fill(color = "#e1e1e1"), cell_text(weight = "bold")),
            locations = cells_column_labels()) |>
  tab_style(style = list(cell_text(weight = "bold")),
            locations = cells_body(columns = 1:2))

## ----fig.width=10, fig.height=7-----------------------------------------------
benchmarkData$comparison |>
  plotCohortOverlap(uniqueCombinations = FALSE, facet = "cdm_name") +
  scale_y_discrete(labels = niceOverlapLabels) +
  theme(
    legend.text = element_text(size = 10),
    strip.text = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  ) +
  # facet_wrap("cdm_name") +
  scale_fill_discrete(labels = c("Both", "CIRCE", "CohortConstructor")) +
  scale_color_discrete(labels = c("Both", "CIRCE", "CohortConstructor"))

## -----------------------------------------------------------------------------
## TABLE with same results as the plot below.

# header_prefix <- "[header]Time by database (minutes)\n[header_level]"
# benchmarkData$time |>
#   distinct() |>
#   filter(!grepl("male|set", msg)) |>
#   mutate(
#     time = niceNum((as.numeric(toc) - as.numeric(tic))/60, 2),
#     Tool = if_else(grepl("cc", msg), "CohortConstructor", "CIRCE"),
#     "Cohort name" = str_to_sentence(gsub("_", " ", gsub("cc_|atlas_", "", msg)))
#   ) |>
#   select(-c("tic", "toc", "msg", "callback_msg")) |>
#   pivot_wider(names_from = "cdm_name", values_from = "time", names_prefix = header_prefix) |>
#   select(c("Cohort name", "Tool", paste0(header_prefix, data$time$cdm_name |> unique()))) |>
#   mutate(
#     "Cohort name" = case_when(
#       grepl("Asthma", .data[["Cohort name"]]) ~ "Asthma without COPD",
#       grepl("Covid", .data[["Cohort name"]]) ~ "COVID-19",
#       grepl("eutropenia", .data[["Cohort name"]]) ~ "Acquired neutropenia or unspecified leukopenia",
#       grepl("Hosp", .data[["Cohort name"]]) ~ "Inpatient hospitalisation",
#       grepl("First", .data[["Cohort name"]]) ~ "First major depression",
#       grepl("fluoro", .data[["Cohort name"]]) ~ "New fluoroquinolone users",
#       grepl("Beta", .data[["Cohort name"]]) ~ "New users of beta blockers nested in essential hypertension",
#       .default = .data[["Cohort name"]]
#     )
#   ) |>
#   arrange(`Cohort name`) |>
#   gtTable(colsToMergeRows = "all_columns") |>
#   tab_style(style = list(cell_fill(color = "#e1e1e1"), cell_text(weight = "bold")), 
#             locations = cells_column_labels()) |>
#   tab_style(style = list(cell_text(weight = "bold")), 
#             locations = cells_body(columns = 1:2)) 

## ----fig.width=10, fig.height=7-----------------------------------------------

benchmarkData$time_definition |>
  ggplot(aes(y = `Cohort name`, x = time, colour = Tool, fill = Tool)) +
  geom_col(position = "dodge", width = 0.6) +
  xlab("Time (minutes)") +
  scale_y_discrete(labels = label_wrap(20)) +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom",
    axis.text.x = element_text(size = 12),
    legend.text = element_text(size = 12),
    strip.text = element_text(size = 14),
    axis.text.y = element_text(size = 12),  
    axis.title.x = element_text(size = 14),  
    axis.title.y = element_text(size = 14)   
  ) +
  facet_wrap(vars(cdm_name), nrow = 1, scales = "free_x")

## -----------------------------------------------------------------------------
header_prefix <- "[header]Time by tool (minutes)\n[header_level]"
benchmarkData$time_domain |>
  formatTable() |> 
  tab_style(style = list(cell_fill(color = "#e1e1e1"), cell_text(weight = "bold")), 
            locations = cells_column_labels()) |>
  tab_style(style = list(cell_text(weight = "bold")), 
            locations = cells_body(columns = 1)) 

## -----------------------------------------------------------------------------
benchmarkData$time_strata |>
  formatTable() |>
  tab_style(style = list(cell_fill(color = "#e1e1e1"), cell_text(weight = "bold")), 
            locations = cells_column_labels()) |>
  tab_style(style = list(cell_text(weight = "bold")), 
            locations = cells_body(columns = 1)) 

## ----fig.width=10, fig.height=7-----------------------------------------------
benchmarkData$sql_indexes |>
  distinct() |>
  group_by(cdm_name, msg) |>
  summarise(time = sum(as.numeric(toc) - as.numeric(tic))/60, .groups = "drop") |>
  mutate(
    Index = if_else(grepl("No index", msg), "Without SQL index", "With SQL index"),
    Domains = str_to_sentence(gsub("No index: |Index: | domains| domain", "", msg)),
    Domains = gsub("procedure ", "procedure, ", Domains)
  ) |>
  ggplot(aes(y = Domains, x = time, colour = Index, fill = Index)) +
  geom_col(position = "dodge", width = 0.6) +
  xlab("Time (minutes)") +
  scale_y_discrete(labels = label_wrap(15)) +
  theme(
    legend.title=element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 12),
    strip.text = element_text(size = 14),
    # axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 12),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12),  
    axis.title.x = element_text(size = 14),  
    axis.title.y = element_text(size = 14)   
  ) +
  facet_wrap(vars(cdm_name), scales = "free_x")


