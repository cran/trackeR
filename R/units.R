#' Get the units of the variables in an \code{distrProfile} object
#'
#' @param object An object of class \code{distrProfile}.
#' @param ... Currently not used.
#' @export
get_units.distrProfile <- function(object, ...) {
    attr(object, "units")
}

#' Get the units of the variables in an \code{conProfile} object
#'
#' @param object An object of class \code{conProfile}.
#' @param ... Currently not used.
#' @export
get_units.conProfile <- function(object, ...) {
    attr(object, "units")
}

#' Get the units of the variables in an \code{trackeRWprime} object
#'
#' @param object An object of class \code{trackeRWprime}.
#' @param ... Currently not used.
#' @export
get_units.trackeRWprime <- function(object, ...) {
    attr(object, "unit")
}

get_units.trackeRfpca <- function(object, ...) {
    attr(object, "units")
}

## conversion functions: distance
#' Auxiliary conversion functions
#'
#' Conversion functions for distance, duration, speed, pace, power,
#' cadence and temperature.
#'
#' @param variable Variable to be converted.
#' @name conversions
#' @export
m2km <- function(variable) {
    variable/1000
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km2m <- function(variable) {
    variable * 1000
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
m2ft <- function(variable) {
    variable * 3937/1200
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft2m <- function(variable) {
    variable * 1200/3937
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
m2mi <- function(variable) {
    variable/1609.344
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi2m <- function(variable) {
    variable * 1.609344 * 1000
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km2ft <- function(variable) {
    variable/1.609344 * 5280
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft2km <- function(variable) {
    variable * 1.609344/5280
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km2mi <- function(variable) {
    variable/1.609344
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi2km <- function(variable) {
    variable * 1.609344
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft2mi <- function(variable) {
    variable/5280
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi2ft <- function(variable) {
    variable * 5280
}

#' @inheritParams conversions
#' @rdname conversions
#' @export
m2m <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km2km <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft2ft <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi2mi <- function(variable) {
    variable
}


## conversion functions: duration
#' @inheritParams conversions
#' @rdname conversions
#' @export
s2min <- function(variable) {
    if (class(variable) == "difftime") {
        units(variable) <- "mins"
    } else {
        variable <- variable/60
    }
    return(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min2s <- function(variable) {
    if (class(variable) == "difftime") {
        units(variable) <- "secs"
    } else {
        variable <- variable * 60
    }
    return(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
s2h <- function(variable) {
    if (class(variable) == "difftime") {
        units(variable) <- "hours"
    } else {
        variable <- variable/60/60
    }
    return(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
h2s <- function(variable) {
    if (class(variable) == "difftime") {
        units(variable) <- "secs"
    } else {
        variable <- variable * 60 * 60
    }
    return(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min2h <- function(variable) {
    if (class(variable) == "difftime") {
        units(variable) <- "hours"
    } else {
        variable <- variable/60
    }
    return(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
h2min <- function(variable) {
    if (class(variable) == "difftime") {
        units(variable) <- "mins"
    } else {
        variable <- variable * 60
    }
    return(variable)
}

#' @inheritParams conversions
#' @rdname conversions
#' @export
h2h <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min2min <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
s2s <- function(variable) {
    variable
}


#' @inheritParams conversions
#' @rdname conversions
#' @export
min2min <- function(variable) {
    variable
}

#' @inheritParams conversions
#' @rdname conversions
#' @export
h2h <- function(variable) {
    variable
}

## conversion functions: degree
#' @inheritParams conversions
#' @rdname conversions
#' @export
degree2degree <- function(variable) {
    variable
}

## conversion functions: speed
#' @inheritParams conversions
#' @rdname conversions
#' @export
m_per_s2km_per_h <- function(variable) {
    variable/1000 * 60 * 60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_h2m_per_s <- function(variable) {
    variable * 1000/60/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
m_per_s2ft_per_min <- function(variable) {
    variable * 3937/1200 * 60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_min2m_per_s <- function(variable) {
    variable/(3937/1200)/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
m_per_s2ft_per_s <- function(variable) {
    variable * 3937/1200
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_s2m_per_s <- function(variable) {
    variable/(3937/1200)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
m_per_s2mi_per_h <- function(variable) {
    variable/1609.344 * 60 * 60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_h2m_per_s <- function(variable) {
    variable * 1609.344/60/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
m_per_s2km_per_min <- function(variable) {
    m_per_s2km_per_h(variable)/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_min2m_per_s <- function(variable) {
    km_per_h2m_per_s(variable * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
m_per_s2mi_per_min <- function(variable) {
    m_per_s2mi_per_h(variable)/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_min2m_per_s <- function(variable) {
    mi_per_h2m_per_s(variable * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_h2ft_per_min <- function(variable) {
    km2ft(variable/60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_min2km_per_h <- function(variable) {
    ft2km(variable * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_h2ft_per_s <- function(variable) {
    km2ft(variable/60/60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_s2km_per_h <- function(variable) {
    ft2km(variable * 60 * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_h2mi_per_h <- function(variable) {
    km2mi(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_h2km_per_h <- function(variable) {
    mi2km(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_h2km_per_min <- function(variable) {
    variable/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_min2km_per_h <- function(variable) {
    variable * 60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_h2mi_per_min <- function(variable) {
    km_per_h2mi_per_h(variable)/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_min2km_per_h <- function(variable) {
    mi_per_h2km_per_h(variable * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_min2ft_per_s <- function(variable) {
    variable/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_s2ft_per_min <- function(variable) {
    variable * 60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_min2mi_per_h <- function(variable) {
    ft2mi(variable * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_h2ft_per_min <- function(variable) {
    mi2ft(variable/60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_min2km_per_min <- function(variable) {
    ft2km(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_min2ft_per_min <- function(variable) {
    km2ft(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_min2mi_per_min <- function(variable) {
    ft2mi(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_min2ft_per_min <- function(variable) {
    mi2ft(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_s2mi_per_h <- function(variable) {
    ft2mi(variable * 60 * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_h2ft_per_s <- function(variable) {
    mi2ft(variable/60/60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_s2km_per_min <- function(variable) {
    ft2km(variable * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_min2ft_per_s <- function(variable) {
    km2ft(variable/60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_s2mi_per_min <- function(variable) {
    ft2mi(variable * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_min2ft_per_s <- function(variable) {
    mi2ft(variable/60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_h2km_per_min <- function(variable) {
    mi2km(variable/60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_min2mi_per_h <- function(variable) {
    km2mi(variable * 60)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_h2mi_per_min <- function(variable) {
    variable/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_min2mi_per_h <- function(variable) {
    variable * 60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_min2mi_per_min <- function(variable) {
    km2mi(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_min2km_per_min <- function(variable) {
    mi2km(variable)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
m_per_s2m_per_s <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_h2km_per_h <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_min2ft_per_min <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
ft_per_s2ft_per_s <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_h2mi_per_h <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
km_per_min2km_per_min <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
mi_per_min2mi_per_min <- function(variable) {
    variable
}


## conversion functions: heart_rate
#' @inheritParams conversions
#' @rdname conversions
#' @export
bpm2bpm <- function(variable) {
    variable
}


## conversion functions: pace
#' @inheritParams conversions
#' @rdname conversions
#' @export
s_per_m2min_per_km <- function(variable) {
    variable * 1000/60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min_per_km2s_per_m <- function(variable) {
    variable/1000 * 60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
s_per_m2min_per_mi <- function(variable) {
    variable/60 * 1609.344
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min_per_mi2s_per_m <- function(variable) {
    variable * 60/1609.344
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min_per_km2min_per_mi <- function(variable) {
    variable * 1.609344
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min_per_mi2min_per_km <- function(variable) {
    variable/1.609344
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min_per_ft2min_per_km <- function(variable) {
  variable/0.0003048
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min_per_ft2min_per_mi <- function(variable) {
  variable/0.000189393939
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
s_per_m2s_per_m <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min_per_km2min_per_km <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
min_per_mi2min_per_mi <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
h_per_km2min_per_km <- function(variable) {
    variable * 60
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
h_per_km2min_per_mi <- function(variable) {
  variable * 60 * mi2km(1)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
h_per_mi2min_per_km <- function(variable) {
    variable * 60 / mi2km(1)
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
h_per_mi2min_per_mi <- function(variable) {
    variable * 60
}


## conversion functions: power
#' @inheritParams conversions
#' @rdname conversions
#' @export
W2kW <- function(variable) {
    variable/1000
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
kW2W <- function(variable) {
    variable * 1000
}

#' @inheritParams conversions
#' @rdname conversions
#' @export
W2W <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
kW2kW <- function(variable) {
    variable
}


## conversion functions: cadence
#' @inheritParams conversions
#' @rdname conversions
#' @export
steps_per_min2steps_per_min <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
rev_per_min2rev_per_min <- function(variable) {
    variable
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
steps_per_min2rev_per_min <- function(variable) {
    ## step defined as half a revolution
    variable/2
}
#' @inheritParams conversions
#' @rdname conversions
#' @export
rev_per_min2steps_per_min <- function(variable) {
    ## step defined as half a revolution
    variable * 2
}

## conversion functions: temperature
#' @inheritParams conversions
#' @rdname conversions
#' @export
C2F <- function(variable) {
    variable * 9 / 5 + 32
}

#' @inheritParams conversions
#' @rdname conversions
#' @export
C2C <- function(variable) {
    variable
}

#' @inheritParams conversions
#' @rdname conversions
#' @export
F2F <- function(variable) {
    variable
}

#' @inheritParams conversions
#' @rdname conversions
#' @export
F2C <- function(variable) {
    (variable - 32) * 5 / 9
}

