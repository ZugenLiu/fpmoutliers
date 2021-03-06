% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wfpi.R
\name{WFPI}
\alias{WFPI}
\title{Weighted Frequent Pattern Isolation}
\usage{
WFPI(data, minSupport = 0.3, mlen = 0, preferredColumn = "",
  preference = 1)
}
\arguments{
\item{data}{\code{data.frame} or \code{transactions} from \code{arules} with input data}

\item{minSupport}{minimum support for FPM}

\item{mlen}{maximum length of frequent itemsets}

\item{preferredColumn}{column name that is preferred}

\item{preference}{numeric value that multiplies the score}
}
\value{
vector with outlier scores
}
\description{
Weighted Frequent Pattern Isolation
}
