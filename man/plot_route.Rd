% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trackeRdata_plot.R, R/zzz_aliases.R
\name{plot_route}
\alias{plot_route}
\alias{plotRoute}
\title{Plot routes for training sessions}
\usage{
plot_route(
  x,
  session = 1,
  zoom = NULL,
  speed = TRUE,
  threshold = TRUE,
  mfrow = NULL,
  maptype = "stamen_terrain",
  messaging = FALSE,
  ...
)

plotRoute(
  x,
  session = 1,
  zoom = NULL,
  speed = TRUE,
  threshold = TRUE,
  mfrow = NULL,
  maptype = "stamen_terrain",
  messaging = FALSE,
  ...
)
}
\arguments{
\item{x}{A object of class \code{\link{trackeRdata}}.}

\item{session}{A numeric vector of the sessions to be plotted. Defaults
to the first session, all sessions can be plotted by \code{session = NULL}.}

\item{zoom}{The zoom level for the background map as passed on to
\code{\link[ggmap]{get_stadiamap}} (2 corresponds roughly to continent
level and 20 to building level).}

\item{speed}{Logical. Should the trace be coloured according to speed?}

\item{threshold}{Logical. Should thresholds be applied?}

\item{mfrow}{A vector of 2 elements, number of rows and number of columns,
specifying the layout for multiple sessions.}

\item{maptype}{Passed to \code{\link[ggmap]{get_stadiamap}}. Default is \code{"stamen_terrain"}.}

\item{messaging}{Passed to \code{\link[ggmap]{get_stadiamap}}. Default is \code{FALSE}.}

\item{...}{Additional arguments passed on to \code{\link{threshold}} and
\code{\link[ggmap]{get_stadiamap}}.}
}
\description{
Plot the route ran/cycled during training onto a background map.
Internet connection is required to download the background map.
}
\details{
\code{plot_route()} requires a a Stadia Maps API key. See \code{\link[ggmap]{register_stadiamaps}} for details.
}
\examples{
\dontrun{
data('runs', package = 'trackeR')
plot_route(runs, session = 4, zoom = 13)
plot_route(runs, session = 4, zoom = 13, maptype = "outdoors")
## multiple sessions
plot_route(runs, session = c(1:4, 8:11))
## different zoom level per panel
plot_route(runs, session = 6:7, zoom = c(13, 14))
}
}
\seealso{
\code{\link[ggmap]{get_stadiamap}}, \code{\link[ggmap]{ggmap}}
}
