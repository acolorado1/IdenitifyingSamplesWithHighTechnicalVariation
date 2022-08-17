# Check dependencies 
require(readr)

#' Read in metadata file 
#' 
#' @param filepath A string 
#' @return A dataframe 
#' @example 
#' metadata_readin("/file.tsv")

# get metadata 
metadata_readin <- function(filepath){ 
  full_meta <- read_delim(filepath, 
                          delim = "\t", escape_double = FALSE, 
                          trim_ws = TRUE)
  # add column for noodle number
  full_meta$noodle <- as.character(full_meta$noodle)
  noodles <- full_meta$noodle
  noodle_nums <- c()
  for(noodle in noodles){
    number <- substr(noodle, nchar(noodle), nchar(noodle))
    noodle_nums <- c(noodle_nums, number)
  }
  full_meta$noodle_num <- noodle_nums
  
  # adjust full metadata df to have just ID as the column name 
  colnames(full_meta)[1] <- "ID"
  return(full_meta)
}

#' Load in one distance matrix as a dataframe
#' 
#' @param FilePath A string 
#' @return A dataframe 
#' @example 
#' get_matrix("/distance_matrix.txt")

# get distance matrix 
get_matrix <-function(FilePath){
  d_matrix <- read_delim(FilePath, 
                         delim = "\t", escape_double = FALSE, 
                         trim_ws = TRUE)
  colnames(d_matrix)[1] <- "ID"
  return(d_matrix)
}
