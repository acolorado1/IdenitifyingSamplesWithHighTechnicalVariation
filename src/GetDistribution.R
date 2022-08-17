#check dependencies 
require(dplyr)

#' Get distributions based on relatedness using matrix 
#' 
#' @param matrix A dataframe 
#' @param metadata A dataframe
#' @param method A string 
#' @param subset_ID A string  
#' @return A dataframe 
#' @example 
#' distance_data_byrelatedness(matrix, metadata, "Jaccard", "Within_noodle)


distance_data_by_relatedness <- function(matrix,
                               metadata,
                               method = c("Jaccard", "Bray Curtis", "Unweighted Unifrac", "Weighted Unifrac"), 
                               subset_ID = c("noodle", "reactor", "sampling_date")){ 
  
  d_matrix_noID <- subset(matrix, select = -ID)
  
  # grab all noodle IDs 
  ID_list <- c()
  
  for (col in colnames(d_matrix_noID)){ 
    this_df <- metadata %>% 
      filter(ID == col)
    this_noodle <- this_df[[subset_ID]]
    ID_list <- c(ID_list, this_noodle)
    
  }
  
  
  len_ID_list <- length(ID_list)
  
  # create matrix where rows have the same value 
  r_mat <- matrix(, nrow = len_ID_list, ncol = len_ID_list)
  
  for (i in 1:len_ID_list){ 
    r_mat[i,] <- ID_list[i]
  }
  
  # create a matrix where all the columns have the same value 
  c_mat <- matrix(, nrow = len_ID_list, ncol = len_ID_list)
  for (i in 1:len_ID_list){ 
    c_mat[,i] <- ID_list[i]
  }
  
  
  # overlay matrices and create a mask 
  # true values will be those with the same subset_ID (e.g. noodle)
  mask <- c_mat == r_mat
  diag(mask) <- F
  
  
  # create output dataframe 
  output_df <- data.frame(matrix(ncol = 3, nrow = 0))
  col_names <- c("Distance", paste0("Within_", subset_ID), "Method")
  colnames(output_df) <- col_names
  
  # keep values that were true in the mask from upper triangle
  t_keep <- d_matrix_noID[upper.tri(d_matrix_noID)][mask[upper.tri(mask)]]
  # keep values that were false in the mask from upper triangle
  f_keep <- d_matrix_noID[upper.tri(d_matrix_noID)][!mask[upper.tri(mask)]]
  
  # create temporary true and false dataframes 
  temp_t_df <- data.frame(matrix(ncol = 3, nrow = length(t_keep)))
  colnames(temp_t_df) <- col_names
  temp_f_df <- data.frame(matrix(ncol = 3, nrow = length(f_keep)))
  colnames(temp_f_df) <- col_names
  
  # add distances found in the matrix 
  temp_t_df$Distance <- t_keep
  temp_f_df$Distance <- f_keep
  
  temp_t_df[[paste0("Within_",subset_ID)]] <- "True"
  temp_f_df[[paste0("Within_",subset_ID)]]<- "False"
  
  output_df <- rbind(output_df, temp_t_df)
  output_df <- rbind(output_df, temp_f_df)
  
  output_df$Method <- method
  
  return(output_df)
}


#' Get distributions by relatedness for all four methods 
#' 
#' @param paths A list of strings 
#' @param metadata A dataframe
#' @param subsetID A string 
#' @return A dataframe 
#' @example 
#' combined_methods_data(c("/jaccard.txt","/bray_curtis.txt", "/unweighted_unifrac.txt","/weighted_unifrac.txt"), 
#' metadata, "noodle")

combined_methods_data <- function(paths, 
                                  metadata, 
                                  subsetID = C("noodle", "reactor", 
                                               "sampling_date")){ 
  # create empty output dataframe 
  full_distance_data <- data.frame(matrix(ncol = 3, nrow = 0))
  col_names <- c("Distance", paste0("Within_", subsetID), "Method")
  colnames(full_distance_data) <- col_names
  
  warning("If file paths are not in the correct order (i.e. Jaccard, 
          Bray Curtis, Unweighted Unifrac and Weighted Unifrac)
          the output will be labeled incorrectly.")
  
  for (i in 1:length(paths)){
    if (i == 1){
      method <- "Jaccard"
    }
    if (i == 2) {
      method <- "Bray Curtis"
    }
    if (i ==3 ){ 
      method <- "Unweighted Unifrac"
    }
    if (i == 4)
    {
      method <- "Weighted Unifrac"
    }
    d_matrix <- get_matrix(paths[i])
    
    new_df <-distance_data_by_relatedness(d_matrix,
                                          full_meta,
                                          method,
                                          subsetID)
    full_distance_data <- rbind(full_distance_data, new_df)
    
    
  }
  
  return(full_distance_data)
  
}  




