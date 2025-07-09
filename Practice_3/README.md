# TESS Light Curve Processing Documentation

This document outlines the methodology and Python script (`practice_3.py`) used to process TESS light curve files for Practice 3. The script performs data loading, preprocessing, outlier identification, plotting of raw light curves, and analysis including phase-folding and Lomb-Scargle periodogram computation.

## Script Overview (`practice_3.py`)

The `practice_3.py` script is designed to automate the analysis of multiple TESS light curve files. It iterates through `.lc` files located in the `/lc_files/` directory, processes each one, and generates two types of plots (raw light curve and phase-folded light curve with periodogram) saved as PDF files in `/plots/`.

The script utilizes several key functions:

1.  `get_lc_data()`: Loads and preprocesses light curve data.
2.  `identify_outliers()`: Identifies and flags outliers in the flux data.
3.  `plot_raw_lc()`: Generates and saves plots of the raw light curves.
4.  `fold_lc()`: Performs phase-folding, Lomb-Scargle periodogram analysis, and generates plots of the folded light curve and periodogram.

### Dependencies

The script relies on the following Python libraries, which are listed in `requirements.txt`:

* `numpy`
* `matplotlib`
* `pandas`
* `astropy` (specifically `astropy.time`, `astropy.timeseries`, and `astropy.units`)

## Processing Steps and Functions

### 1. Data Loading and Preprocessing (`get_lc_data`)

The `get_lc_data` function is responsible for loading and preparing the TESS light curve files.
Each light curve file is read from the `lc_data_folder`. The function parses three main columns: `TIME`, `PDCSAP_FLUX`, and `PDCSAP_FLUX_ERR`.

Key preprocessing steps include:
* Converting `BTJD` (Barycentric TESS Julian Date) time to `JD` (Julian Date) in the `TDB` (Barycentric Dynamical Time) scale. This is done by adding 2457000.0 to the `BTJD` values.
* Converting each `BJD` timestamp to a UTC calendar date string (YYYY-MM-DD format). This `date` string is added as a new column to the `TimeSeries` object and is crucial for grouping data by observation date in subsequent plotting and outlier detection.
* Handling missing data by dropping rows with `NaN` values.
* Returning an `Astropy TimeSeries` object containing `time`, `flux` (in e-/s), `flux_err` (in e-/s), and `date` columns.

### 2. Outlier Identification (`identify_outliers`)

The `identify_outliers` function performs a robust sigma-clipping method to detect outliers in the light curve flux data.

* For each unique observing date, the function calculates the median and Median Absolute Deviation (MAD) of the flux values.
* Points deviating more than a specified `threshold` (defaulting to 3) times the robust sigma estimate (calculated as 1.4826 multiplied by the MAD) are flagged as outliers.
* The function returns a boolean mask indicating the location of outliers.

### 3. Raw Light Curve Plotting (`plot_raw_lc`)

The `plot_raw_lc` function generates scatter plots of the raw light curves. These plots include error bars for flux values against BJD Epoch.

To enhance readability and accessibility:
* The script uses distinct markers and a colorblind-friendly palette for data points corresponding to unique observation dates.
* A legend is included to distinguish the dates, placed in multiple columns below the plot to avoid overlapping data.
* Axis labels (`BJD Epoch`, `PDCSAP Flux (e-/s)`) and a title (`Raw Light Curve of [filename]`) are provided for clarity.
* Outliers identified by `identify_outliers` are highlighted with a distinct black 'x' marker.
* The plots are saved as PDF files in the `/plots/` directory.

### 4. Phase-Folding and Periodogram Analysis (`fold_lc`)

The `fold_lc` function analyzes and plots a phase-folded light curve and its Lomb-Scargle periodogram.

The process involves:
* **Data Preparation:** Outliers identified by `identify_outliers` are masked out before further analysis.
* **Lomb-Scargle Periodogram:** The Lomb-Scargle periodogram is computed to find the best period within a defined range (defaulting from 0.1 to 10 days). This is achieved using `astropy.timeseries.LombScargle`.
* **Phase Folding:** The light curve is then phase-folded using the `best_period` found from the periodogram analysis.
* **Amplitude Estimation:** The amplitude is estimated from the folded light curve as the difference between the 97.5th and 2.5th percentiles of the cleaned flux values.
* **Plot Generation:** A two-subplot figure is generated, displaying:
    * The phase-folded light curve, with different markers/colors for data from distinct observation dates.
    * The Lomb-Scargle periodogram.
    * Annotations providing the estimated initial `BJD_0`, the best period, and the estimated amplitude.
* The plots are saved as PDF files in the `/plots/` directory.

### Important Considerations from Practice 3 Solution

As noted in the original solution for Practice 3, not all light curves fold perfectly. The periodograms often exhibit spurious peaks due to various factors, including:
* Dropping of `NaN` values from the data.
* Gaps in the TESS observations.
* The signal not being a perfect sinusoid.
* Presence of aliases due to the observation setup.

These factors mean that the highest peak in the periodogram does not always guarantee the true best frequency, and results require careful interpretation.
