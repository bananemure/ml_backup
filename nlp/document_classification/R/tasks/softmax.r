## from http://tr.im/hH5A
logsumexp <- function (x) {
  y = max(x)
  y + log(sum(exp(x - y)))
}

softmax <- function (x) {
  x <- x[!is.na(x)]
  exp(x - logsumexp(x))
}