################################
## Project: Twitter NLP
## Purpose of file:
##    1) Figure out how to read JSON data file
##    2) Explore the data
##
################################

library("rjson")
library(jsonlite)
json <- "./Data/4senti-tw-json.log.2017-03-25"
#tw_json <- fromJSON(file=json)
#dat <- fromJSON(paste(readLines("./Data/4senti-tw-json.log.2017-03-25"),collapse = ""))
  # issues with parse quote
dat <- stream_in(file("./Data/4senti-tw-json.log.2017-03-25"))
head(dat$fxSentiment)
head(dat$user)
table(dat$user$lang) # freq table of lang

tw.id <- dat$user$id[dat$user$lang=="en"]
twt <- dat$fxSentiment[(dat$fxSentiment$id %in% tw.id),]
str(dat$user)
