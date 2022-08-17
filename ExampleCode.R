source("./src/DataReadIn.R")
source("./src/GetDistribution.R")
source("./src/Plots.R")
source("./src/SummaryOfDistribution.R")

metadata_fp <- "C:/Users/ascol/OneDrive/Desktop/Miller2022/2022_Spring_GB_16S_metadata.tsv"
jaccard_fp <- "C:\\Users\\ascol\\OneDrive\\Desktop\\Miller2022\\testing\\14_240_paired_2_2\\jaccard.tsv"
bray_fp <- "C:\\Users\\ascol\\OneDrive\\Desktop\\Miller2022\\testing\\14_240_paired_2_2\\bray_curtis.tsv"
uw_uni_fp <- "C:\\Users\\ascol\\OneDrive\\Desktop\\Miller2022\\testing\\14_240_paired_2_2\\unweighted_unifrac.tsv"
w_uni_fp <- "C:\\Users\\ascol\\OneDrive\\Desktop\\Miller2022\\testing\\14_240_paired_2_2\\weighted_unifrac.tsv"

f_paths <- c(jaccard_fp, bray_fp, uw_uni_fp, w_uni_fp)

full_meta <- metadata_readin(metadata_fp)
test_matrix <- get_matrix(jaccard_fp)

test_distribution <- distance_data_by_relatedness(test_matrix, 
                                                  full_meta, 
                                                  method = "Jaccard", 
                                                  subset_ID = "noodle")
test_combo <- combined_methods_data(f_paths, 
                                    full_meta, 
                                    subsetID = "noodle")

plot_by_relatedness(test_combo, "Within_noodle", "15", "1045")
plot_by_relatedness(test_distribution, "Within_noodle", "15", "1045")

summary_of_distributions(test_combo, "Within_noodle")
summary_of_distributions(test_distribution, "Within_noodle")





