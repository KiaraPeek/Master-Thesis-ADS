# README Causalcasemix
This project was created to investigate how changes in case-mix affect discrimination and calibration of diagnostic and prognostic prediction models. 

## Structure of the project
- `data`
  - `raw`
  - `processed`
    - `1a_process_ari.R`
    - `1a_process_news.R`
  - `metadata`
    - `ari-description.qmd`
    - `news-description.qmd`
    - `metadata_ari.json`
    - `metadata_news.json`
- `scripts`
  - `2_fitmodels.R`
  - `3_plot_results.R`
- `results`
  - `results_1trainenv.csv`
  - `graphics`
    - `arrow_plot_trainenv_int.pdf`
    - `arrow_plot_trainenv_slope.pdf`
    - `ari`
      - AUC plots and calibration plots for each environment in the dataset and each task in `metadata_ari.json`
    - `news`
      - AUC plots and calibration plots for each environment in the dataset and each task in `metadata_news.json`

# Get started
## Download data
To reproduce the results from this project, the data needs to be downloaded and stored correctly:
- Download ari.zip from WHO ARI Multicentre Study of clinical signs and etiologic agents on http://hbiostat.org/data [1]
- Download the full dataset from https://doi.org/10.5061/dryad.d22q6vh [2]
- Store the raw datafiles under `data/raw`

[1] courtesy of the Vanderbilt University Department of Biostatistics

[2] Eckart, Andreas et al. (2018). Data from: Combination of the National Early Warning Score (NEWS) and inflammatory biomarkers for early risk stratification in emergency department patients: results of a multi-national, observational study [Dataset]. Dryad. 

## Scripts
- In `ari-description.qmd` and `news-description.qmd` the datasets are explored
- In `1a_process_ari.R` and `1a_process_news.R`:
  -   the raw data is processed
  -   the new processed data is stored under `data/processed`
  -   metadata files are created for both datasets: `metadata_ari.json` and `metadata_news.json`, and stored under `data/metadata`
- In `2_fitmodels.R` logistic regression models are fit with the task information in the metadata files and evaluated with AUC and calibration plots which are stored in `results/graphics` and a results table is created `results_1trainenv.csv`
- In `3_plot_results.R` the results table `results_1trainenv.csv` is used to plot arrows from the discrimination and calibration scores of the training set to the different test sets (`arrow_plot_trainenv_int.pdf` and `arrow_plot_trainenv_slope.pdf`), and the mean values for the results table are calculated.
