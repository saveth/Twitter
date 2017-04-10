################################
## Project: Twitter NLP
## Purpose of file:
##    1) Create Word Cloud for twitter tweets
##    2) Explore the data
##
################################
library(textcat)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(stringr)

tw <- read.csv("./Data/10M.csv", header = FALSE, quote = "")
tw$tweets2 <- gsub("\\s*https.*","\\1", tw$V3) # remove hyperlinks
url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
tw$url<- str_extract(tw$V3, url_pattern)

#Create a column of only clean tweets
#tw$tweets3 <- gsub("^.*:", "", tw$tweets2) #only removes the colon
tw$tweets3 <- str_replace(tw$tweets2,"RT @[a-z,A-Z,0-9,_]*: ","") # removes the RT and handle
tw$tweets3 <- gsub("@\\w+", "", tw$tweets3) #removes the twitter handle of non-RT
tw$tweets3 <- str_replace_all(tw$tweets3,"#[a-zA-Z]*","") #remove hashtag
tw$retweet <- str_extract(tw$tweets2, "RT @[a-z,A-Z,0-9,_]*: ")

#Emojis
#emoji <- /[\u{00A9}\u{00AE}\u{203C}\u{2049}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2604}\u{260E}\u{2611}\u{2614}-\u{2615}\u{2618}\u{261D}\u{2620}\u{2622}-\u{2623}\u{2626}\u{262A}\u{262E}-\u{262F}\u{2638}-\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2692}-\u{2694}\u{2696}-\u{2697}\u{2699}\u{269B}-\u{269C}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26B0}-\u{26B1}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26C8}\u{26CE}-\u{26CF}\u{26D1}\u{26D3}-\u{26D4}\u{26E9}-\u{26EA}\u{26F0}-\u{26F5}\u{26F7}-\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270D}\u{270F}\u{2712}\u{2714}\u{2716}\u{271D}\u{2721}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2763}-\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{27BF}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F321}\u{1F324}-\u{1F393}\u{1F396}-\u{1F397}\u{1F399}-\u{1F39B}\u{1F39E}-\u{1F3F0}\u{1F3F3}-\u{1F3F5}\u{1F3F7}-\u{1F4FD}\u{1F4FF}-\u{1F53D}\u{1F549}-\u{1F54E}\u{1F550}-\u{1F567}\u{1F56F}-\u{1F570}\u{1F573}-\u{1F579}\u{1F587}\u{1F58A}-\u{1F58D}\u{1F590}\u{1F595}-\u{1F596}\u{1F5A5}\u{1F5A8}\u{1F5B1}-\u{1F5B2}\u{1F5BC}\u{1F5C2}-\u{1F5C4}\u{1F5D1}-\u{1F5D3}\u{1F5DC}-\u{1F5DE}\u{1F5E1}\u{1F5E3}\u{1F5EF}\u{1F5F3}\u{1F5FA}-\u{1F64F}\u{1F680}-\u{1F6C5}\u{1F6CB}-\u{1F6D0}\u{1F6E0}-\u{1F6E5}\u{1F6E9}\u{1F6EB}-\u{1F6EC}\u{1F6F0}\u{1F6F3}\u{1F910}-\u{1F918}\u{1F980}-\u{1F984}\u{1F9C0}]/
# tw$tweets4 <- gsub("<.*>","", tw$tweets3)


tw$hashtag <- str_extract_all(tw$tweets2, "#[a-zA-Z]{1,}")
tw$hashtag <- sapply(tw$hashtag, paste,collapse= ", ")

tw$lang1 <- textcat(tw$tweets2)
tw$lang2 <- textcat(tw$tweets3)


tw$tweets3 <- gsub("\"", "", tw$tweets3)
tw$tweets3 <- gsub("[[:punct:]]","",tw$tweets3)
tw3 <- tw$tweets3[tw$lang2=="english"]
tw3 <- tw3[!is.na(tw3)] 
write.table(tw3, "./Data/tweet3.txt", row.names = FALSE, quote = FALSE)


#SET UP  TWEETS for WordCloud
tw.eng <- Corpus(VectorSource(tw$tweets3[tw$lang2=="english"]))
inspect(tw.eng)
tw.eng <- tm_map(tw.eng,content_transformer(tolower))
tw.eng <- tm_map(tw.eng, removePunctuation)
tw.eng <- tm_map(tw.eng, removeNumbers)
tw.eng <- tm_map(tw.eng, removeWords, stopwords("english"))
tw.eng <- tm_map(tw.eng, stripWhitespace)
inspect(tw.eng)

tw.text <- TermDocumentMatrix(tw.eng)
tw.mat <- as.matrix(tw.text)
tw.srt <- sort(rowSums(tw.mat), decreasing = TRUE)
tw.wrd <- data.frame(word = names(tw.srt), freq = tw.srt)
head(tw.wrd, 10)

set.seed(1234)
pdf("./Data/tweets200com.pdf", width = 7, height = 5)
wordcloud(words = tw.wrd$word, freq = tw.wrd$freq, min.freq = 1,
          max.words=400, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
dev.off()

# Setup Data for ggplot
library(ggplot2)
library(dplyr)
language <- tw %>%
  mutate_each(funs(factor(.)),lang2) %>%
  group_by(lang2) %>%
  summarise( N = n()) %>%
  arrange(N) %>%
  mutate(lang2 =factor(lang2, lang2)) %>%
  filter(!is.na(lang2)) %>%
  select(lang2,N)
  
gglang <- ggplot(language, aes(x=lang2, y = N)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  #scale_fill_gradient2(low = "red",mid = "snow3" ,high = "darkgreen", space = "Lab") +
  ggtitle("Frequency of languages used in Twitter") +
  labs(x = "Language", y = "Frquency") +
  theme_bw()
gglang
    # Note that it Sanskit is the 3rd language, but it's mostly Japanese, which doesn't have a unicode
    # It's a composite of 3 other unicode languages


#SET UP  TWEETS for WordCloud
has.eng <- Corpus(VectorSource(tw$hashtag))
has.eng <- tm_map(has.eng, removePunctuation)
pdf("./Data/hashtag1.pdf", width = 7, height = 5)
wordcloud(has.eng, max.words = 300, min.freq = 1, random.color = TRUE, random.order = FALSE) 
dev.off()

hash.df <- TermDocumentMatrix(has.eng)
hash.df <- as.matrix(hash.df)
hash.df <- sort(rowSums(hash.df), decreasing = TRUE)
hash.df <- data.frame(word = names(hash.df), freq = hash.df)
head(hash.df, 10)



pdf("./Data/hashtag.pdf", width = 7, height = 5)
wordcloud(words = hash.df$word, freq = hash.df$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
dev.off()

#####
# What do we know about the data?
#####
summary(tw[, !colnames(tw) %in% c("hashtag","V3")])
table(tw$retweet)
  # None of retweet were duplicates
table(!is.na(tw$retweet))
  # half of the tweets are retweets

table(is.na(tw$url))
  # about half of the tweets contains a url
