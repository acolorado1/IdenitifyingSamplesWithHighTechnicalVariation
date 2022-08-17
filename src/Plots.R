require(ggplot2)
require(ggpubr)

#' Plot density distributions 
#' 
#' @param data A dataframe 
#' @param fill_column A string 
#' @param y_axis_limit A integer 
#' @param sampling_depth A string 
#' @param save_density A string 
#' @return plots a figure and can save a png 
#' @example plot_by_relatedness(dataframe, "Within_noodle", 50, "1045", "no")


plot_by_relatedness <- function(data, 
                                fill_column,
                                y_axis_limit = 50,
                                sampling_depth = "", 
                                save_density = "no"){ 
  # create density plot 
  density_plot <- ggplot(data, aes_string(x = "Distance", 
                                          fill = fill_column))+ 
    geom_density(alpha = 0.2)+ 
    theme_bw() + 
    labs(x = "Distance", y = "Density") +  
    ylim(0, y_axis_limit)+
    scale_x_continuous(breaks = seq(0,1, by = 0.1))+
    facet_wrap(~Method)+ 
    ggtitle("Sampling Depth: ",sampling_depth )
  
  # create histogram 
  histogram <- ggplot(data, aes_string(x = "Distance", 
                                       fill = fill_column))+ 
    geom_histogram(alpha=0.5)+
    theme_bw() + 
    labs(x = "Distance", y = "Count") +  
    facet_wrap(~Method)
  
  # to create a png file 
  if (save_density == "yes"){ 
    png("density_plot.png")
    print(density_plot)
    dev.off()
  }
  
  # if subset column is by noodle it creates a histogram of just the true values 
  if(fill_column == "Within_noodle"){ 
    true_subset <- subset(data, Within_noodle == "True")
    true_plot <- ggplot(true_subset, aes(x = Distance)) + 
      geom_histogram(fill = "sky blue" , alpha=0.5)+
      theme_bw() + 
      labs(x = "Distance", y = "Count") + 
      facet_wrap(~Method) 
    # plot 3 figures 
    ggarrange(density_plot, histogram, true_plot)
  }else{
    # plot 2 figures 
    ggarrange(density_plot, histogram)
  }
  
}









