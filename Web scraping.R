
library(httr)
library(scrapeR)
library(XML)
library(rjson)
library(RCurl)

URL1 <-"https://www.nationalgeographic.com/photography/photo-of-the-day/"

today<-format(Sys.Date(), format="%B %d, %Y")

#Download the page
src1 <- GET(URL1)

#Format html code
parsed1<-htmlParse(src1, useInternalNodes = T)

URL <- as.character(xpathApply(parsed1,"//meta[@property='og:url']/@content")[1])

#Download the page
src <- GET(URL)

#Format html code
parsed<-htmlParse(src, useInternalNodes = T)
content<-as.character(xpathApply(parsed,"//meta[@property='og:description']/@content")[1])

content <- if(grepl('\'',content)) gsub(pattern = '\'',replacement = '\'\'',content) else content

# Code to fetch image from meta tags
pic <- as.character(xpathApply(parsed,"//meta[@property='og:image']/@content")[1])

#Get title of the content (h1)
myTitle<-as.character(xpathApply(parsed1,"//meta[@property='og:title']/@content")[1])
myTitle <- if(grepl('\'',myTitle)) gsub(pattern = '\'',replacement = '\'\'',myTitle) else myTitle

# Writing fetched data to csv file
scrape_data <- data.frame(Title = myTitle, PicURL = pic, Article = content, stringsAsFactors=FALSE)

write.csv(scrape_data, file = "scraped_data.csv")
