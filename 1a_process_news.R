#' The goal of this script is to process news from raw to processed
#' 
#' 
library(jsonlite)
library(haven)
library(dplyr)
library(foreign)
library(tidyr)

data_path <- here::here('data', 'raw', 'NEWS_datafile.xls')
raw_data <- readxl::read_excel(data_path)

news <- raw_data

# data cleaning: remove duplicates
news <- distinct(news)

# process the data 
news <- news %>%
  filter(hospital != "Aarau") %>%
  mutate(
    los_geq3 = ifelse(LOS >= 3, 1, 0),
    spo2_leq97 = ifelse(SpO2 <= 97, 1, 0)
  )%>%
  select(hospital, age, SpO2, LOS, temp, ICU, los_geq3, spo2_leq97)%>%
  drop_na()

# save the processed data to a new CSV file in the 'processed' folder
processed_file_path <- here::here('data', 'processed', 'processed_news.csv')
write.csv(news, processed_file_path, row.names = FALSE)

# converting 'ICU', 'los_geq3' and 'spo2_leq97' to factors
news$ICU <- as.factor(news$ICU)
news$los_geq3 <- as.factor(news$los_geq3)
news$spo2_leq97 <- as.factor(news$spo2_leq97)

# check missing data for selected variables
missing_data <- colSums(is.na(news))

# check data type for selected variables
data_types <- sapply(news, class)

# check number of unique values for categorical variables
unique_values <- sapply(news, function(x) length(unique(x)))

# check summary table
summary_table <- data.frame(
  Variables = names(news),
  Missing_Data = missing_data,
  Data_Type = data_types,
  Unique_Values = unique_values
)

# save the table to a CSV file
write.csv(summary_table, "summary_table_news.csv", row.names = FALSE)

# generate data_json
data_json <- list(
  tag = "news",
  full_name = "news",
  url = "https://datadryad.org/stash/dataset/doi:10.5061/dryad.d22q6vh",
  description = "Combination of the National Early Warning Score (NEWS) and inflammatory biomarkers for early risk stratification",
  num_rows = nrow(news),
  num_columns = ncol(news),
  column_names = colnames(news),
  column_data_types = sapply(news, class),
  creation_date = Sys.Date(),
  source_file = "NEWS_datafile.xls",
  tasks = list(
    list(
      tag = "task_1",
      outcome_variable = "los_geq3",
      type = "prognosis",
      features = c("age","temp","ICU","spo2_leq97")
    ),list(
      tag = "task_2",
      outcome_variable = "spo2_leq97",
      type = "diagnosis",
      features = c("age","temp","ICU","los_geq3"))
  ),
  test_environment = "hospital"
)

# convert metadata to JSON format
metadata <- toJSON(data_json, pretty = TRUE, auto_unbox = TRUE)

# save metadata to a JSON file
metadata_file_path <- here::here('data', 'metadata', 'metadata_news.json')
writeLines(metadata, metadata_file_path)
