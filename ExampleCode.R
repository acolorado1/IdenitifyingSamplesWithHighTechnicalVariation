source("./src/DataReadIn.R")
source("./src/GetDistribution.R")
source("./src/Plots.R")
source("./src/SummaryOfDistribution.R")

metadata_fp <- "./data/2022_Spring_GB_16S_metadata.tsv"
jaccard_fp <- "./data/experiments/14_240_paired_2_2/distance_matrices_1045/jaccard.tsv"
bray_fp <- "./data/experiments/14_240_paired_2_2/distance_matrices_1045/bray_curtis.tsv"
uw_uni_fp <- "./data/experiments/14_240_paired_2_2/distance_matrices_1045/unweighted_unifrac.tsv"
w_uni_fp <- "./data/experiments/14_240_paired_2_2/distance_matrices_1045/weighted_unifrac.tsv"

f_paths <- c(jaccard_fp, bray_fp, uw_uni_fp, w_uni_fp)


full_meta <- metadata_readin(metadata_fp)

# get output distance dataframe 
test_distribution_data <- combined_methods_data(f_paths, 
                                    full_meta, 
                                    subsetID = "noodle")

# plot distributions 
## sampling depth is 1045 as the file is in the distance_matrices_1045 directory 
plot_by_relatedness(test_distribution_data, "Within_noodle", "15", "1045")

# get summary stats of distributions 
summary_of_distributions(test_distribution_data, "Within_noodle")





