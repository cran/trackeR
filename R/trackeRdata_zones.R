#' Time spent in training zones.
#'
#' @param object An object of class \code{\link{trackeRdata}}.
#' @param session A numeric vector of the sessions to be plotted,
#'     defaults to all sessions.
#' @param what A vector of variable names.
#' @param breaks A list of breakpoints between zones, corresponding to
#'     the variables in \code{what}.
#' @param parallel Logical. Should computation be carried out in
#'     parallel? If \code{TRUE} computation is performed in parallel
#'     using the backend provided to \code{\link{foreach}}. Default is
#'     \code{FALSE}.
#' @param n_zones numeric that sets the number of zones for data to be
#'     split into. Default is \code{9}.
#' @param unit_reference_sport The sport to inherit units from
#'     (default is taken to be the most frequent sport in
#'     \code{object}).
#' @param ... Currently not used.
#' @return An object of class \code{trackeRdataZones}.
#' @seealso \code{\link{plot.trackeRdataZones}}
#' @examples
#' data('run', package = 'trackeR')
#' runZones <- zones(run, what = 'speed', breaks = list(speed = c(0, 2:6, 12.5)))
#' ## if breaks is a named list, argument 'what' can be left unspecified
#' runZones <- zones(run, breaks = list(speed = c(0, 2:6, 12.5)))
#' ## if only a single variable is to be evaluated, 'breaks' can also be a vector
#' runZones <- zones(run, what = 'speed', breaks = c(0, 2:6, 12.5))
#' plot(runZones)
#' @export
zones <- function(object,
                  session = NULL,
                  what = c("speed"),
                  breaks = NULL, #list(speed = 0:10,  heart_rate = c(0, seq(75, 225, by = 50), 250)),
                  parallel = FALSE,
                  n_zones = 9,
                  unit_reference_sport = NULL,
                  ...) {

    ## select sessions
    if (is.null(session)) {
        session <- seq_along(object)
    }
    object <- object[session]

    units <- get_units(object)

    if (is.null(unit_reference_sport)) {
        unit_reference_sport <- find_unit_reference_sport(object)
    }
    ## Match units to those of unit_reference_sport
    un <- collect_units(units, unit_reference_sport = unit_reference_sport)
    for (va in unique(un$variable)) {
        units$unit[units$variable == va] <- un$unit[un$variable == va]
    }
    ## Change units according to unit_reference_sport
    object <- change_units(object, units$variable, units$unit, units$sport)

    duration_unit <- un$unit[un$variable == "duration"]
    du <- switch(duration_unit, "s" = "secs", "min" = "mins", "h" = "hours", "d" = "days")


    if (is.null(breaks)) {
        ## limits <- compute_limits(object, a = 0.025)
        ## for (feature in what) {
        ##     if (all(is.na(limits[[feature]]))) {
        ##         warning(paste('no data for', feature))
        ##         what <- what[!(what %in% feature)]
        ##         limits[[feature]] <- NULL
        ##     }
        ## }

        ## break_points <- function(maximum, minimum = 0) {
        ##     value_range <- as.character(ceiling(maximum - minimum))
        ##     range_size <- nchar(value_range)
        ##     round_table <- list('1' = 5, '2' = 5, '3' = 10, '4' = 100,
        ##                         '5' = 10000, '6' = 100000)
        ##     maximum <- ceiling(maximum/round_table[[range_size]]) * round_table[[range_size]]
        ##     step_size <- round((maximum - minimum) / (n_zones), 1)
        ##     break_points <- seq(minimum, minimum + n_zones * step_size, by = step_size)
        ##     break_points
        ## }


        ## for (feature in what) {
        ##     maximum <- ceiling(limits[[feature]][2])
        ##     minimum <- floor(limits[[feature]][1])
        ##     breaks[[feature]] <- break_points(maximum, minimum)
        ## }
        breaks <- compute_breaks(object, a = 0.025, n_breaks = n_zones, what = what)
        what0 <- what
        what <- names(breaks)
        inds <- match(what0, what, nomatch = 0) == 0
        if (any(inds)) {
            warning(paste("no data for", paste(what0[inds], collapse = ", ")))
        }
    }

    ## process zone definitions
    if (!missing(what) && length(what) == 1 & !is.list(breaks)) {
        breaks <- list(breaks)
        names(breaks) <- what
    }
    if (missing(what) & is.null(names(breaks))) {
        stop("Variable names need to be provided either in 'what' or the names of 'breaks'.")
    }
    if (missing(what)) {
        what <- names(breaks)
    }
    if (is.null(names(breaks))) {
        names(breaks) <- what
    }

    ## facets
    ## utility function
    zones_for_single_variable <- function(sess, what, breaks) {
        nb <- length(breaks)
        feature <- sess[, what]
        dur <- timeAboveThreshold(sess[, "speed"], 0, ge = TRUE)  ## use what or speed?
        ta <- sapply(breaks, function(thr) timeAboveThreshold(feature, thr, ge = TRUE))
        td <- -diff(ta)
        perc <- td/as.numeric(dur) * 100

        inds_gr <- sapply(breaks, "<=", feature)
        inds_le <- !inds_gr
        out <- apply(inds_gr[, -nb] & inds_le[, -1], 2, function(ind) {
            colMeans(sess[ind, ], na.rm = TRUE)
        })
        out <- t(out)
        colnames(out) <- paste0("avg_", colnames(out))

        ## set time spent in zones to minutes
        attr(td, "units") <- units(dur)
        class(td) <- "difftime"
        units(td) <- du

        ret <- data.frame(variable = what, zone = 1:(nb - 1),
                          lower = breaks[-nb],
                          upper = breaks[-1],
                          time = td,
                          percent = perc,
                          out)
        return(ret)
    }

    ## get time in zones
    zones_fun <- function(j, w) {
        sess <- object[[j]]
        zones_for_single_variable(sess, what = w, breaks = breaks[[w]])
    }

    ret <- list()

    for (i in what) {
        foreach_object <- eval(as.call(c(list(quote(foreach::foreach),
                                              j = seq.int(nsessions(object)),
                                              .combine = "rbind"))))
        if (parallel) {
            setup_parallel()
            zonesForVar <- foreach::`%dopar%`(foreach_object, zones_fun(j, i))
        }
        else {
            zonesForVar <- foreach::`%do%`(foreach_object, zones_fun(j, i))
        }
        ret[[i]] <- data.frame(session = rep(session,
                                             each = length(breaks[[i]]) - 1),
                               zonesForVar)
        rownames(ret[[i]]) <- NULL
    }

    attr(ret, "unit_reference_sport") <- unit_reference_sport
    attr(ret, "units") <- get_units(object)
    class(ret) <- c("trackeRdataZones", class(ret))
    return(ret)
}

#' Plot training zones.
#'
#' @param x An object of class \code{trackeRdataZones} as returned by \code{\link{zones}}.
#' @param percent Logical. Should the relative or absolute times spent training in the different zones be plotted?
#' @param ... Currently not used.
#' @examples
#' \dontrun{
#' data('run', package = 'trackeR')
#' runZones <- zones(run, what = 'speed', breaks = c(0, 2:6, 12.5))
#' plot(runZones, percent = FALSE)
#' }
#' @export
plot.trackeRdataZones <- function(x,
                                  percent = TRUE,
                                  ...) {

    dat <- do.call("rbind", x)

    dat$zoneF <- factor(paste0("[", paste(dat$lower, dat$upper, sep = "-"), ")"), levels = unique(paste0("[",
        paste(dat$lower, dat$upper, sep = "-"), ")")))

    dat$Session <- dat$session  ## rename for legend title
    dat$timeN <- as.numeric(dat$time)

    ## basic plot
    p <- ggplot(dat) + xlab("Zones")

    ## y: time or percent
    if (percent) {
        p <- p + geom_bar(aes_(x = quote(zoneF), y = quote(percent),
            fill = quote(Session), group = quote(Session)), stat = "identity", position = position_dodge()) +
            ylab("Percent")
    }
    else {
        p <- p + geom_bar(aes_(x = quote(zoneF), y = quote(timeN), fill = quote(Session),
            group = quote(Session)), stat = "identity", position = position_dodge()) +
            ylab(paste0("Time [", units(dat$time), "]"))
    }


    units <- get_units(x)
    ## Match units to those of unit_reference_sport
    un <- collect_units(units, unit_reference_sport = attr(x, "unit_reference_sport"))
    for (va in unique(un$variable)) {
        units$unit[units$variable == va] <- un$unit[un$variable == va]
    }

    ## Change units to those of unit_reference_sport
    object <- changeUnits(x, un$variable, un$unit, un$sport)


    duration_unit <- un$unit[un$variable == "duration"]
    du <- switch(duration_unit, "s" = "secs", "min" = "mins", "h" = "hours", "d" = "days")


    ## facets
    lab_data <- function(series) {
        thisunit <- un$unit[un$variable == series]
        prettyUnit <- prettifyUnits(thisunit)
        paste0(series, "\n[", prettyUnit, "]")
    }
    lab_data <- Vectorize(lab_data)

    p <- p + facet_grid(. ~ variable, scales = "free_x", labeller = labeller(variable = lab_data))

    ## theme
    p <- p + theme_bw()  +
        theme(axis.text.x = element_text(angle = 50, hjust = 1),
                       panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank())

    return(p)
}

#' @export
nsessions.trackeRdataZones <- function(object,
                                       ...) {
    length(unique(object[[1]]$session))
}

#' Get the units of the variables in an \code{trackeRdataZones} object
#'
#' @param object An object of class \code{trackeRdataZones}.
#' @param ... Currently not used.
#' @export
get_units.trackeRdataZones <- function(object, ...) {
    attr(object, "units")
}


#' Change the units of the variables in an \code{trackeRdataZones} object
#'
#' @param object An object of class \code{trackeRdataZones}.
#' @param variable A vector of variables to be changed. Note, these are expected to be
#'     concepts like 'speed' rather than variable names like 'avgSpeed' or 'avgSpeedMoving'.
#' @param unit A vector with the units, corresponding to variable.
#' @param ... Currently not used.
#' @export
change_units.trackeRdataZones <- function(object,
                                          variable,
                                          unit,
                                          ...) {

    no_variable <- missing(variable)
    no_unit <- missing(unit)

    if (no_unit & no_variable) {
        return(object)
    }
    else {
        ## NOTE: variable is expected to contain concepts like 'speed' rather than variable
        ## names like 'avgSpeed' or 'avgSpeedMoving'.
        units <- get_units(object)
        current <- collect_units(units, unit_reference_sport = attr(object, "unit_reference_sport"))
        p <- length(variable)

        if (length(unit) == p) {
            ## no need for collect_units as this is already done in summary

            mt <- attr(object, "moving_threshold")

            for (i in variable) {
                variables <- names(object)[grep(pattern = i, names(object), ignore.case = TRUE)]
                currentUnit <- current$unit[current$variable == i]
                newUnit <- unit[which(variable == i)]
                if (currentUnit != newUnit) {
                    conversion <- match.fun(paste(currentUnit, newUnit, sep = "2"))
                    ## change zone limits
                    object[[i]]$lower <- conversion(object[[i]]$lower)
                    object[[i]]$upper <- conversion(object[[i]]$upper)
                    ## convert moving threshold
                    if (i == "speed")
                        mt <- conversion(mt)
                    ## update units
                    current$unit[current$variable == i] <- newUnit
                }
            }

            ## update units in units
            for (va in current$variable) {
                units$unit[units$variable == va] <- current$unit[current$variable == va]
            }

            attr(object, "units") <- units
            attr(object, "moving_threshold") <- mt
        }
        else {
            stop("variable, unit and sport should have the same length.")
        }

    }
}
