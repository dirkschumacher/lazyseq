#' A lazy list
#'
#' A lazy list is a list of rlang quosures.
#' Each element is only evaluated when needed. I.e. when
#' casted to a list (e.g. using \code{as.list}) or accessed using \code{[[}.
#'
#' @param ... a list of expressions that are captured and
#' only evaluated on demand.
#'
#' @examples
#' library(lazyseq)
#' val <- 10
#' ll <- lazy_list(print(1), print(!!val), stop("will never execute"))
#' ll[[1]]
#' ll[[2]]
#' as.list(ll[-3])
#'
#' @export
lazy_list <- function(...) {
  calls <- enquos(...)
  has_names <- !is.null(names(calls)) && any(names(calls) != "")
  if (has_names) {
    stop("A lazy list does not support named parameters at the moment")
  } else {
    names(calls) <- NULL
  }
  new_lazy_list(calls)
}

quos_ptype <- quos(1)[-1]
new_lazy_list <- function(data = list()) {
  new_list_of(data, ptype = quos_ptype, class = "lazyseq_list")
}
methods::setOldClass(c("lazyseq_list", "vctrs_vctr"))

#' Checks if the object is a lazy list
#'
#' @param x any object
#'
#' @export
is_lazy_list <- function(x) {
  inherits(x, "lazyseq_list")
}

#' @export
`[[.lazyseq_list` <- function(x, i) {
  eval_tidy(vec_data(x)[[i]])
}

#' @export
`[[<-.lazyseq_list` <- function(x, i, value) {
  data <- vec_data(x)
  data[[i]] <- if (is_quosure(value)) {
    value
  } else {
    as_quosure(value)
  }
  new_lazy_list(data)
}

#' @export
format.lazyseq_list <- function(x, ...) {
  paste0("<lazy_list[", length(vec_data(x)) ,"]>")
}

#' @export
print.lazyseq_list <- function(x, ...) {
  cat(paste0(format(x), "\n"))
}

#' @export
vec_ptype_abbr.lazyseq_list <- function(x, ...) {
  "lazy_list"
}

#' @export
vec_ptype2.lazyseq_list.lazyseq_list <- function(x, y, ...) new_lazy_list()

#' @export
vec_ptype2.list.lazyseq_list <- function(x, y, ...) list()

#' @export
vec_ptype2.lazyseq_list.list <- function(x, y, ...) list()

#' @export
vec_cast.lazyseq_list.lazyseq_list <- function(x, to, ...) {
  x
}

#' @export
vec_cast.list.lazyseq_list <- function(x, to, ...) {
  lapply(seq_along(x), function(i) {
    x[[i]]
  })
}

#' @export
as.list.lazyseq_list <- function(x, ...) {
  vec_cast(x, list())
}
