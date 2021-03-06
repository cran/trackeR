% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trackeRdata_summary.R
\name{change_units.trackeRdataSummary}
\alias{change_units.trackeRdataSummary}
\title{Change the units of the variables in an \code{trackeRdataSummary} object}
\usage{
\method{change_units}{trackeRdataSummary}(object, variable, unit, ...)
}
\arguments{
\item{object}{An object of class \code{trackeRdataSummary}.}

\item{variable}{A vector of variables to be changed. Note, these are expected to be
concepts like 'speed' rather than variable names like 'avgSpeed' or 'avgSpeedMoving'.}

\item{unit}{A vector with the units, corresponding to variable.}

\item{...}{Currently not used.}
}
\description{
Change the units of the variables in an \code{trackeRdataSummary} object
}
