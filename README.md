Identifying Samples with High Technical Variation
================
Angela Sofia Burkhart Colorado
2022-08-16

## Description

This script will identify 16S sequencing samples with high technical
variation. Right now it takes distance matrices generated through
standard dada2 pipeline in QIIME2. The four kinds of distances metrics
are Jaccard, Bray Curtis, Unweighted and Weighted Unifrac. Any and all
of these matrices can be used in this implementation. With those
matrices this script will output density curves containing two
distributions. The first will be of distances found between more closely
related samples and the second will be of distances between samples that
were less closely related.

## Workflow

### Arguments

Should one want information on a distribution of **one** distance
metric, further arguments that are needed include:

1.  Metric (or method) used **e.g. Jaccard**
2.  subset_ID (delimited to distinguish between related and unrelated
    samples) **e.g. noodle**

Should one want information on **all four** distance matrices, the only
other argument needed is:

1.  subset_ID (delimited to distinguish between related and unrelated
    samples) **e.g. noodle**

When plotting distributions there are four arguments:

1.  Dataframe containing distributions
2.  column name of delimiter **e.g. Within_noodle** (this column will
    always begin with **Within\_**)
3.  y limit for the plot (integer)
4.  Sampling depth that was used when calculating the matrices in QIIME

To plot summary statistics the only arguments needed are **1 & 2** of
the arguments used in the plots.

### Inputs

To run this script you will need two file types:

1.  metadata file (.tsv)
2.  distance matrix file (.txt)

Metadata example:

    ## # A tibble: 6 x 18
    ##   ID    BarcodeSequence LinkerP~1 lowry~2 orig_~3 sampling~4 reactor noodle quarter 1-4-D~5 1-4-Diox~6 Tetra~7 Tetrahyd~8 total~9
    ##   <chr> <lgl>           <lgl>     <chr>   <chr>   <date>     <chr>   <chr>  <chr>     <dbl> <date>       <dbl> <date>       <dbl>
    ## 1 CM001 NA              NA        01-18-~ 01-17-~ 2022-01-18 R1      2022-~ C         15000 2022-01-18   16000 2022-01-18      82
    ## 2 CM002 NA              NA        01-18-~ 01-18-~ 2022-01-18 R2      2022-~ C         15000 2022-01-18   16000 2022-01-18      82
    ## 3 CM003 NA              NA        01-18-~ 01-18-~ 2022-01-18 R2      2022-~ D         15000 2022-01-18   16000 2022-01-18      82
    ## 4 CM004 NA              NA        01-18-~ 01-18-~ 2022-01-18 R2      2022-~ C         15000 2022-01-18   16000 2022-01-18      82
    ## 5 CM005 NA              NA        01-18-~ 01-18-~ 2022-01-18 R2      2022-~ D         15000 2022-01-18   16000 2022-01-18      82
    ## 6 CM006 NA              NA        01-18-~ 01-18-~ 2022-01-18 R2      2022-~ C         15000 2022-01-18   16000 2022-01-18      82
    ## # ... with 4 more variables: total_N_sed_tank_sampling_date <date>, `1-2-Dichloroethane_sed_tank_ug_per_L` <dbl>,
    ## #   `1-2-Dichloroethane_sed_tank_sampling_date` <date>, noodle_num <chr>, and abbreviated variable names
    ## #   1: LinkerPrimerSequence, 2: lowry_sample_ID, 3: orig_lowry_sample_id, 4: sampling_date, 5: `1-4-Dioxane_sed_tank_ug_per_L`,
    ## #   6: `1-4-Dioxane_sed_tank_sampling_date`, 7: Tetrahydrofuran_sed_tank_ug_per_L, 8: Tetrahydrofuran_sed_tank_sampling_date,
    ## #   9: total_N_sed_tank_ug_per_L
    ## # i Use `colnames()` to see all variable names

Distance matrix example:

    ## # A tibble: 6 x 321
    ##   ID    CM001 CM002 CM003 CM005 CM006 CM007 CM009 CM012 CM015 CM018 CM020 CM021 CM023 CM024 CM025 CM027 CM032 CM033 CM037 CM039
    ##   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1 CM001 0     0.685 0.544 0.619 0.615 0.576 0.704 0.552 0.588 0.640 0.614 0.700 0.593 0.642 0.657 0.584 0.630 0.608 0.692 0.686
    ## 2 CM002 0.685 0     0.689 0.596 0.756 0.696 0.792 0.667 0.651 0.707 0.657 0.786 0.675 0.528 0.776 0.533 0.7   0.719 0.693 0.789
    ## 3 CM003 0.544 0.689 0     0.562 0.577 0.547 0.643 0.478 0.545 0.497 0.591 0.627 0.532 0.626 0.623 0.562 0.517 0.580 0.673 0.618
    ## 4 CM005 0.619 0.596 0.562 0     0.667 0.575 0.691 0.5   0.5   0.549 0.603 0.680 0.512 0.559 0.680 0.505 0.572 0.539 0.630 0.723
    ## 5 CM006 0.615 0.756 0.577 0.667 0     0.599 0.581 0.583 0.623 0.580 0.708 0.557 0.632 0.751 0.537 0.658 0.604 0.594 0.789 0.594
    ## 6 CM007 0.576 0.696 0.547 0.575 0.599 0     0.606 0.574 0.587 0.605 0.684 0.644 0.601 0.68  0.659 0.604 0.584 0.589 0.734 0.656
    ## # ... with 300 more variables: CM040 <dbl>, CM041 <dbl>, CM042 <dbl>, CM044 <dbl>, CM045 <dbl>, CM047 <dbl>, CM048 <dbl>,
    ## #   CM049 <dbl>, CM051 <dbl>, CM057 <dbl>, CM060 <dbl>, CM061 <dbl>, CM064 <dbl>, CM065 <dbl>, CM066 <dbl>, CM068 <dbl>,
    ## #   CM078 <dbl>, CM080 <dbl>, CM081 <dbl>, CM084 <dbl>, CM085 <dbl>, CM086 <dbl>, CM087 <dbl>, CM088 <dbl>, CM089 <dbl>,
    ## #   CM091 <dbl>, CM094 <dbl>, CM095 <dbl>, CM096 <dbl>, CM098 <dbl>, CM100 <dbl>, CM101 <dbl>, CM107 <dbl>, CM108 <dbl>,
    ## #   CM110 <dbl>, CM112 <dbl>, CM113 <dbl>, CM114 <dbl>, CM115 <dbl>, CM116 <dbl>, CM117 <dbl>, CM118 <dbl>, CM120 <dbl>,
    ## #   CM121 <dbl>, CM124 <dbl>, CM125 <dbl>, CM126 <dbl>, CM128 <dbl>, CM130 <dbl>, CM131 <dbl>, CM132 <dbl>, CM134 <dbl>,
    ## #   CM135 <dbl>, CM140 <dbl>, CM141 <dbl>, CM142 <dbl>, CM143 <dbl>, CM144 <dbl>, CM145 <dbl>, CM147 <dbl>, CM148 <dbl>, ...
    ## # i Use `colnames()` to see all variable names

## Outputs

The following is an examples of the distance distribution dataframe
output:

    ##    Distance Within_noodle  Method
    ## 1 0.6890756          True Jaccard
    ## 2 0.5990099          True Jaccard
    ## 3 0.6375000          True Jaccard
    ## 4 0.5798319          True Jaccard
    ## 5 0.7155172          True Jaccard
    ## 6 0.6465517          True Jaccard

### Plots

Density plots generated appear as the following:

![Plots of
Distributions](data/experiments/14_240_paired_2_2/plots_in_git/distribution_plots.png)

Tables and a box plot can also be output to summarize the distributions
generated.

![Summary Statistic
Output](data/experiments/14_240_paired_2_2/plots_in_git/summary_stats_output.png)

## Installation and Dependencies

You must have R installed. This was written in R-4.1.2 on a
Windows-based operatin system. Packages readr, dplyr, ggplot2, and
ggpubr will be required.

## Contact

Angela Sofia Burkhart Colorado -
<angelasofia.burkhartcolorado@cuanschutz.edu>

Project Link -
<https://github.com/acolorado1/IdenitifyingSamplesWithHighTechnicalVariation.git>
