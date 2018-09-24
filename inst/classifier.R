library(doMC)
registerDoMC(8)

sessions1 <- readDirectory("~/Downloads/kantas_activities/",
                           aggregate = FALSE, parallel = TRUE)

sessions <- list()
base_dir <- "/Users/yiannis/Documents/Projects/Runners/Data/TCX\ files/"
for (directory in dir(base_dir)) {
    sessions[[directory]] <- readDirectory(paste0(base_dir, "/", directory),
                                           silent = TRUE,
                                           parallel = TRUE, aggregate = FALSE)
}



sessions <- c(sessions1, sessions2)

session_summaries <- summary(sessions, movingThreshold = 0)
session_summaries <- changeUnits(session_summaries, c("duration", "distance"), c("h", "km"))

clean_summaries <- as.data.frame(session_summaries)[c("duration",
                                                      "distance",
                                                      "avgSpeed",
                                                      "avgPace",
                                                      "wrRatio",
                                                      "session",
                                                      "sport",
                                                      "avgAltitude",
                                                      "file")]

## Train a multinomial logit model
library("nnet")
dat <- na.omit(clean_summaries)
mod <- multinom(sport ~ duration + distance + avgSpeed, data = clean_summaries)

## In-sample summaries
probs <- fitted(mod)
## predicted <- colnames(probs)[apply(probs, 1, which.max)]
predicted <- predict(mod, dat)
actual <- dat$sport
xtabs(~ actual + predicted)

## Which did we miss?
ind <- which(predicted != actual)
dat$sport[ind]
predicted[ind]
dat$file[ind]
round(probs[ind, ], 3)
plot(sessions, session = dat$session[ind], what = c("speed", "pace", "altitude"))

## Out-of-sample summaries
out <- as.data.frame(session_summaries)[is.na(session_summaries$sport), ]
predicted <- predict(mod, out)
plot(sessions, session = out$session, what = c("speed", "pace", "altitude"))


##
ss <- changeUnits(ss, c("duration", "distance"), c("h", "km"))
predict(mod, ss)

predict(mod, changeUnits(summary(sess[7]), c("duration", "distance"), c("h", "km")))


