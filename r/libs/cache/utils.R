

#' Create a cache key for an object
#'
#' @param obj The object to create a cache key for
#' @return The cache key
#' @example
#' key <- create_cache_key(list(1, 2, 3))
#' print(key)
#' #> [1] 'b1b8e3e8b4b0
#' @export
create_cache_key <- function(obj) digest::digest(obj)


#' Remove all files in the cache directory
#' @export
clear_caches <- function() {
  files <- list.files(PATHS$DIR_CACHE, full.names = TRUE)
  file.remove(files)
}
