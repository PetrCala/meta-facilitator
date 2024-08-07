box::use(
  libs / validation[validate]
)

#' Pluralize a word
#'
#' @param word [character] The word to pluralize
#' @return [character] The pluralized word
pluralize <- function(word) {
  validate(is.character(word))
  if (grepl("[sxz]$", word) || grepl("[sc]h$", word)) {
    return(paste0(word, "es"))
  } else if (grepl("[^aeiou]y$", word)) {
    return(sub("y$", "ies", word))
  } else {
    return(paste0(word, "s"))
  }
}
