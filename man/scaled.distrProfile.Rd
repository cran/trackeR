% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distributionProfile.R
\name{scaled.distrProfile}
\alias{scaled.distrProfile}
\title{Scale the distribution profile relative to its maximum value.}
\usage{
\method{scaled}{distrProfile}(object, session = NULL, what = NULL, ...)
}
\arguments{
\item{object}{An object of class \code{distrProfile} as returned by
\code{\link{distributionProfile}}.}

\item{session}{A numeric vector of the sessions to be selected and
scaled. Defaults to all sessions.}

\item{what}{A character version of the variables to be selected and
scaled. Defaults to all variables in \code{object} (\code{what
= NULL}).}

\item{...}{Currently not used.}
}
\description{
Scale the distribution profile relative to its maximum value.
}
