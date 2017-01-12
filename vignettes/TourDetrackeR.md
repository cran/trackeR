---
title: "Tour de trackeR"
author: "[Hannah Frick](http://www.ucl.ac.uk/~ucakhfr) and [Ioannis Kosmidis](http://www.ucl.ac.uk/~ucakiko/)"
date: "2017-01-11"
output: rmarkdown::html_vignette
bibliography: trackeR.bib
vignette: >
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteIndexEntry{Tour de trackeR}
  %\VignetteEncoding{UTF-8}
---


The **trackeR** package provides infrastructure for handling running and cycling
data from GPS-enabled tracking devices. A short demonstration of its functionality is
provided below, based on data from running activities. A more comprehensive introduction
to the package can be found in the vignette "Infrastructure for Running and
Cycling Data", which can be accessed by typing


```r
vignette("trackeR", package = "trackeR")
```


## Reading data

**trackeR** can currently import files in the Training Centre XML (TCX) format and
.db3 files (SQLite databases, used, for example, by devices from GPSports) through the
corresponding functions *readTCX*() and *readDB3*(). It also offers experimental support
for JSON files from [Golden Cheetah](http://www.goldencheetah.org/) via *readJSON*().


```r
library("trackeR")
filepath <- system.file("extdata", "2013-06-08-090442.TCX", package = "trackeR")
runDF <- readTCX(file = filepath, timezone = "GMT")
```

These read functions return a `data.frame` of the following structure


```r
str(runDF)
```

```
## 'data.frame':	1191 obs. of  9 variables:
##  $ time      : POSIXct, format: "2013-06-08 08:04:42" "2013-06-08 08:04:43" ...
##  $ latitude  : num  51.4 51.4 51.4 51.4 51.4 ...
##  $ longitude : num  1.04 1.04 1.04 1.04 1.04 ...
##  $ altitude  : num  6.2 6.2 6.2 6.2 6.2 ...
##  $ distance  : num  0 1.68 5.28 8.33 14.88 ...
##  $ heart.rate: num  83 84 84 86 89 93 96 98 101 102 ...
##  $ speed     : num  0 0.594 1.416 1.928 2.614 ...
##  $ cadence   : num  NA 54 74 97 97 97 97 98 97 97 ...
##  $ power     : num  NA NA NA NA NA NA NA NA NA NA ...
```

That `data.frame` can be used as an input to the constructor function for **trackeR**'s
*trackeRdata* class, to produce a session-based and unit-aware object that can be used
for further analyses.


```r
runTr0 <- trackeRdata(runDF)
```

```
## Warning in sanityChecks(dat = dat, silent = silent): Observations with
## duplicated time stamps are removed.
```

The *readContainer*() function combines the two steps of importing the data and constructing
the *trackeRdata* object.


```r
runTr1 <- readContainer(filepath, type = "tcx", timezone = "GMT")
```

```
## Warning in sanityChecks(dat = dat, silent = silent): Observations with
## duplicated time stamps are removed.
```

```r
identical(runTr0, runTr1)
```

```
## [1] TRUE
```

The *readDirectory*() function can be used to read `all` supported files in a directory and
produce the corresponding *trackeRdata* objects.



## Visualisations

The package includes an example data set which can be accessed through


```r
data("runs", package = "trackeR")
```

The default behaviour of the *plot* method for *trackeRdata* objects
is to show how heart rate and pace evolve over the session.


```r
plot(runs, session = 1:7)
```

![plot of chunk plot_runs](figure/plot_runs-1.png)

The elevation profile of a training session is also accessible, here along with the pace.


```r
plot(runs, session = 27, what = c("altitude", "pace"))
```

![plot of chunk plot_runs_2](figure/plot_runs_2-1.png)

The route taken during a training session can also be plotted on maps from various sources
e.g., from Stamen Maps or OpenStreetMap. This can be done either on a static map


```r
plotRoute(runs, session = 4, zoom = 13, source = "stamen")
```

![plot of chunk plotRoute](figure/plotRoute-1.png)

or on an interactive map.


```r
leafletRoute(runs, session = 8:13)
```

```
## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

```
## Warning in normalizePath(f2): path[1]="./webshot2c143ec4eb68.png": No such
## file or directory
```

```
## Warning in file(con, "rb"): cannot open file './webshot2c143ec4eb68.png':
## No such file or directory
```

```
## Error in file(con, "rb"): cannot open the connection
```



## Session summaries

The summary of sessions includes basic statistics like duration,
time spent moving, average speed, pace, and heart rate. The speed threshold used to
distinguish moving from resting can be set by the argument *movingThreshold*.


```r
summary(runs, session = 1, movingThreshold = 1)
```

```
## 
##  *** Session 1 ***
## 
##  Session times: 2013-06-01 17:32:15 - 2013-06-01 18:37:56 
##  Distance: 14130.7 m 
##  Duration: 1.09 hours 
##  Moving time: 1.07 hours 
##  Average speed: 3.59 m_per_s 
##  Average speed moving: 3.67 m_per_s 
##  Average pace (per 1 km): 4:38 min:sec
##  Average pace moving (per 1 km): 4:32 min:sec
##  Average cadence: 88.66 steps_per_min 
##  Average cadence moving: 88.87 steps_per_min 
##  Average power: NA W 
##  Average power moving: NA W 
##  Average heart rate: 141.11 bpm 
##  Average heart rate moving: 141.13 bpm 
##  Average heart rate resting: 136.76 bpm 
##  Work to rest ratio: 42.31 
## 
##  Moving threshold: 1 m_per_s
```

It is usually desirable to visualise summaries from multiple sessions. This can be done
using the *plot* method for summary objects. Below, we produce such a plot for average
heart rate, average speed, distance, and duration.


```r
runsSummary <- summary(runs)
plot(runsSummary, group = c("total", "moving"),
  what = c("avgSpeed", "distance", "duration", "avgHeartRate"))
```

![plot of chunk plot_summary](figure/plot_summary-1.png)

The timeline plot is useful to visualise the date and time that the sessions took place and
provide information of their relative duration.


```r
timeline(runsSummary)
```

![plot of chunk timeline](figure/timeline-1.png)



## Time in zones

The time spent training in certain zones, e.g., speed zones, can also be calculated and
visualised.


```r
runZones <- zones(runs[1:4], what = "speed", breaks = c(0, 2:6, 12.5))
plot(runZones)
```

![plot of chunk plot_zones](figure/plot_zones-1.png)



## Quantifying work capacity via W' (W prime)

*trackeR* can also be used to calculate and visualise the work capacity W' (pronounced
as `W prime`). The comprehensive vignette "Infrastructure for Running and Cycling Data"
provides the definition of work capacity and details on the *version* and *quantity* arguments.


```r
wexp <- Wprime(runs, session = 11, quantity = "expended", cp = 4, version = "2012")
plot(wexp, scaled = TRUE)
```

![plot of chunk plot_Wprime](figure/plot_Wprime-1.png)



## Distribution and concentration profiles

@trackeR:Kosmidis+Passfield:2015 introduce the concept of distribution and concentration
profiles for which **trackeR** provides an implementation. These profiles are motivated
by the need to compare sessions and use information on such variables as heart rate or
speed during a session for further modelling.

The distribution profile for a variable such as speed or heart rate describes the time
exercising above a (speed or heart rate) threshold.

Here, the distribution profiles for the first 4 sessions are calculated for speed with
thresholds ranging from 0 to 12.5 m/s in increments of 0.05 m/s.


```r
dProfile <- distributionProfile(runs, session = 1:4, what = "speed",
  grid = list(speed = seq(0, 12.5, by = 0.05)))
plot(dProfile, multiple = TRUE)
```

![plot of chunk distProfile](figure/distProfile-1.png)

Sessions 4 and 1 are longer than session 2 and 3, as visible by the higher amount of time
spent exercising above 0 m/s. However sessions 3 and 4 show a larger amount of time spent
exercising above 4 m/s than the other sessions. This is easier to spot in the concentration
profiles which are the negative derivative of the distribution profiles.
The concentration profile for session 3 has a mode at around 3.5 meters per second and
another one above 4 meters per second, showing that this session involved training at a
combination of low and high speeds.


```r
cProfile <- concentrationProfile(dProfile, what = "speed")
plot(cProfile, multiple = TRUE)
```

![plot of chunk conProfile](figure/conProfile-1.png)

More details on distribution and concentration profiles can be found in the comprehensive
vignette "Infrastructure for Running and Cycling Data".



## Functional principal components analysis

The distribution and concentration can be used for further analysis such as a functional
principal components analysis (PCA) to describe the differences between the profiles.

The concentration profiles for all session 


```r
runsT <- threshold(runs)
dpRuns <- distributionProfile(runsT, what = "speed")
dpRunsS <- smoother(dpRuns, cores = 2)
cpRuns <- concentrationProfile(dpRunsS)
plot(cpRuns, multiple = TRUE, smooth = FALSE)
```

![plot of chunk prep_profiles](figure/prep_profiles-1.png)

vary in their shape (unimodal or multimodal), height, and location (revealing
concentrations at higher or lower speeds). The function *funPCA*() can be used
to fit a functional PCA, here with 4 principal components.


```r
cpPCA <- funPCA(cpRuns, what = "speed", nharm = 4)
```

For the speed concentration profiles here, the first two components cover
92% of the variability in the profiles. 


```r
round(cpPCA$varprop, 2)
```

```
## [1] 0.66 0.25 0.06 0.02
```

```r
plot(cpPCA, harm = 1:2)
```

![plot of chunk plot_fPCA](figure/plot_fPCA-1.png)

A plot of the first two principal components reveals that the profiles here differ mostly
in the general height of the curves and the location. These two aspects of the profiles
can be captured by two univariate measures of the sessions, the time spent moving and the
average speed moving. 


```r
## plot scores vs summary statistics
scoresSP <- data.frame(cpPCA$scores)
names(scoresSP) <- paste0("speed_pc", 1:4)
d <- cbind(runsSummary, scoresSP)

library("ggplot2")
## pc1 ~ session duration (moving)
ggplot(d) + geom_point(aes(x = as.numeric(durationMoving), y = speed_pc1)) + theme_bw()
## pc2 ~ avg speed (moving)
ggplot(d) + geom_point(aes(x = avgSpeedMoving, y = speed_pc2)) + theme_bw()
```

![plot of chunk plot_scores](figure/plot_scores-1.png)![plot of chunk plot_scores](figure/plot_scores-2.png)


## References
