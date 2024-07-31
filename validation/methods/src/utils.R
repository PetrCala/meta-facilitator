#' Load a single data frame from the 'data' folder
load_data <- function(file_name) {
  data_folder <- "data"
  full_path <- file.path(data_folder, file_name)
  if (!file.exists(full_path)) {
    stop(paste("File", full_path, "does not exist."))
  }
  message("Reading data from ", full_path)

  df <- readxl::read_excel(path = full_path)

  if (ncol(df) < 2) {
    stop("Data must have at least two columns. Try setting different separators.")
  }

  message("Data loaded successfully.")

  return(df)
}

save_data <- function(results, file_name) {
  data_folder <- "data"
  full_path <- file.path(data_folder, file_name)
  message(paste("Creating a data frame from the results list under path", full_path))

  out <- list()
  for (method in names(results)) {
    res <- results[[method]]
    out[[paste0(method, "_est")]] <- res$est
    out[[paste0(method, "_t_value")]] <- res$t_value
  }

  # Some elements might be numeric(0) here - replace with NA to allow for data frame conversion
  out <- lapply(out, function(x) if (length(x) == 0) NA else x)

  writexl::write_xlsx(as.data.frame(out), path = full_path)
}

#' Read and return the static YAML file as a list
read_static <- function() {
  file_name <- "static.yaml"
  if (!file.exists(file_name)) {
    stop(paste("File", file_name, "does not exist."))
  }
  return(yaml::read_yaml(file_name))
}