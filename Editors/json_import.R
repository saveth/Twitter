################################
## Project: Twitter NLP
## Purpose of file:
##    1) Figure out how to read JSON data file
##    2) Create smaller datasets for AWS test
##
################################

########################
## Dataset 1
########################
#read in file and examine structure of data
library(jsonlite)
dat <- stream_in(file("./Data/4senti-tw-json.log.2017-03-25"))
head(dat$fxSentiment) # Data table created by Wojtek's friend
head(dat$user)
table(dat$user$lang) # freq table of lang
str(dat$contributors)
str(dat$withheldInCountries)
summary(dat$favorited)
str(dat$place)

# Create dataset of interested variables
#dat2 <- cbind(dat$createdAt, dat$id, dat$text, dat$source, 
#              dat$inReplyToScreenName, dat$inReplyToStatusId, dat$inReplyToUserId,
#              dat$geolocation, dat$favorited, dat$retweeted, dat$favoriteCount,
#              dat$user, dat$retweet, dat$retweetCount, dat$retweetedByMe, dat$currentUserRetweetId,
#              dat$possiblySensitive, dat$lang, dat$quotedStatusId)
#colnames(dat2) <- gsub("dat\\$","",colnames(dat2))

#user, geoplocation
vars <- c("createdAt", "id", "text", "source", "inReplyToScreenName","inReplyToStatusId",
          "inReplyToUserId", "favorited", "retweeted", "favoriteCount",
          "retweet", "retweetCount", "retweetedByMe", "currentUserRetweetId",
          "possiblySensitive","lang", "quotedStatusId")

dat2 <- cbind(dat[,vars], dat$user, dat$geolocation)
dat2 <- dat2[dat2$lang=="en",]

# write dataset to upload to AWS
write.csv(dat2,"Data/4senti-2017-03-25.csv", row.names = FALSE)
write.csv(dat2[1:1000,],"Data/4senti-2017-03-25-small1000obs.csv", row.names = FALSE) #to use to test R kernal
saveRDS(dat2,"Data/4senti-2017-03-25.rds" ) # for local use
#Day 1 dataset contains 249,750 obs

########################
## Dataset 2
########################
day2 <- stream_in(file("./Data/4senti-tw-json.log.2017-03-26"))
day2_short <- cbind(day2[,vars], day2$user, day2$geolocation)
day2_short <- day2_short[day2_short$lang=="en",]

# write dataset to upload to AWS
write.csv(day2_short,"Data/4senti-2017-03-26.csv", row.names = FALSE)
write.csv(day2_short[1:1000,],"Data/4senti-2017-03-26-small1000obs.csv", row.names = FALSE) #to use to test R kernal
saveRDS(day2_short,"Data/4senti-2017-03-26.rds" ) # for local use
#Day 1 dataset contains 398,888 obs
