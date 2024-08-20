SPECIAL_KEYS <- c("description", "details", "type", "optional", "default", "values")

#' @title Nullable lapply
#' @description A version of lapply that disassigns items from a list in case their value is NULL. In case the result is empty, return NULL.
#' @param x A list
#' @param FUN A function
#' @return A list
nullable_lapply <- function(x, FUN) {
  stopifnot(is.function(FUN))
  out <- list()
  names <- names(x)
  argcount <- length(formals(FUN)) # Number of arguments
  if (!argcount %in% c(1, 2)) {
    stop("Your function must contain either one or two arguments.")
  }
  for (i in seq_along(x)) {
    name <- names[[i]]
    fun_ <- if (argcount == 2) "FUN(i, x[[name]])" else "FUN(x[[name]])"
    out[[name]] <- eval(parse(text = fun_)) # Assigns nothing if the return is NULL
  }
  if (length(out) == 0) NULL else out
}

is_special_key <- function(node_name) node_name %in% SPECIAL_KEYS

#' Extract special keys from anode
#'
#' @param node A list to extract special keys from
#' @return A list with two elements: keys and node. The node element is the original node with the special keys removed. The keys element is a list with the special keys.
extract_special_keys <- function(node) {
  stopifnot(is.list(node))
  keys_ <- list()
  nodes_ <- list()
  names_ <- names(node)
  for (i in seq_along(node)) {
    node_name <- names_[[i]]
    if (is_special_key(node_name)) {
      keys_[[node_name]] <- node[[i]]
    } else {
      nodes_[[node_name]] <- node[[i]]
    }
  }
  return(list(
    keys = keys_,
    nodes = nodes_
  ))
}

parse_node <- function(node, node_name) {
  if (!is.list(node)) rlang::abort(paste(node_name, "must be a list"))
  paste("Parsing node", node_name)
  if (is_special_key(node_name)) rlang::abort("Should have been parsed before")

  if (length(node) == 0) {
    stop(paste("Empty node", node_name))
  }

  sk_list <- extract_special_keys(node)
  special_keys <- sk_list$keys # Special keys of this node
  child_nodes <- sk_list$nodes # Node without special keys

  if (length(child_nodes) == 0) { # Final node
    stopifnot(length(special_keys) != 0)
    if ("default" %in% names(special_keys)) {
      return(special_keys$default)
    }
    if (!is.null(special_keys$optional) && special_keys$optional) {
      return(NULL) # Only when the optional is truthy
    }
    msg <- paste0(node_name, ": ")
    val <- readline(msg)
    return(val)
  }

  nullable_lapply(child_nodes, function(i, child_node) {
    parse_node(child_node, names(child_nodes)[[i]])
  })
}

#' Parse a source config file and return it as a list
parse_src_config <- function(src_config_path) {
  print(paste("Parsing source config", src_config_path))
  src <- yaml::read_yaml(file = src_config_path)
  parse_node(src, "root")
}

create_new_setup_file <- function() {
  src_config_file_name <- "input.yaml"
  src_config_path <- file.path(src_config_file_name)
  parsed_src_config <- parse_src_config(src_config_path)
  new_file_name <- parsed_src_config$headers$source_file
  print(paste("Writing", new_file_name))
  yaml::write_yaml(parsed_src_config, file = new_file_name)
}

create_new_setup_file()
