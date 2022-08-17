require(dplyr)
require(ggpubr)
require(ggplot2)

#' Get summary statistics of distributions 
#' 
#' @param data A dataframe output by any of the GetDistribution functions 
#' @param subsetID A string of column name containing delimiter 
#' @return a plot containing two tables and a boxplot 
#' @example 
#' summary_of_distributions(distribution_data, "Within_noodle")

summary_of_distributions <- function(data, 
                                     subsetID = c("Within_noodle", "Within_reactor", "Within_sampling_date")){
  
  # Get summary statistics for both distributions for all methods present 
  columns_wanted <- c("Method", subsetID)
  summary_tib <- data %>% 
    group_by_at(columns_wanted)%>%
    summarise(Median = median(Distance), 
              Mean = mean(Distance), 
              Max = max(Distance), 
              Min = min(Distance),
              SD = sd(Distance)
    )
  summary_tib <- ggtexttable(summary_tib)
  
  
  # plot box plots of distributions 
  boxplot <- ggplot(data, aes_string(x = subsetID, y = "Distance", 
                                     fill = "Method"))+
    geom_boxplot() + 
    theme_bw() 
  
  
  # perform wilcoxon signed rank test on the distrubitons 
  res <- data %>% 
    group_by(Method)%>% 
    summarise(
      wilcoxon = eval(parse(text = paste("wilcox.test(Distance ~", subsetID,", exact = F)$p.value")))
    )
  res <- as.data.frame(res)
  
  # perform KS test 
  method_list <- sort(unique(data$Method))
  ks_p_values <- c()
  for (current_method in method_list){ 
    subset_method <- subset(data, Method == current_method)
    true <-  subset_method[subset_method[[subsetID]] == "True",]
    false <- subset_method[subset_method[[subsetID]] == "False",]
    ks_res <- ks.test(true$Distance, false$Distance)
    ks_p_values <- c(ks_p_values, ks_res$p.value) 
  }
  res$KS <- ks_p_values
  
  res <- ggtexttable(res)
  
  #plot summary stats, box plots, and p-values 
  ggarrange(summary_tib, # first row
            ggarrange(boxplot, res, ncol = 2), 
            nrow = 2
  )
}
