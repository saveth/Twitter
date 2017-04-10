#install.packages("textcat")
library(textcat)
tw <- read.csv("/Data/1000.csv", header = FALSE)

tweets <- tw$V3

tw$lang <- textcat(tw$V3)

lang <- as.factor(tw$lang)

barplot(table(lang)[table(lang)>5], ylab = "Frequencies")
barplot(prop.table(table(lang)), freq = TRUE, xlab = levels(lang), ylab = "Frequencies")

barplot(summary(lang))


library(ggplot2)
gglang <- ggplot(as.data.frame(lang), aes(x=lang)) +
  geom_bar()
gglang
