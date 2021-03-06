#Call 'pdftools' package for pdf text extraction
library(pdftools)

#Extract text from pdf
pdf_text("D:\\Files\\CV_1.pdf")

#Split text into lines
library(magrittr)
cv_jy<-pdf_text("D:\\Files\\CV_1.pdf") %>% strsplit(split = "\n")
cv_jy<-pdf_text("D:\\Files\\CV_1.pdf") %>% strsplit(split = "\r")

#Call 'tm' package for text mining
library(tm)

#Set data source
source_text<-VectorSource(cv_jy)

#Set data source as corpus
CV_Corpus<-Corpus(source_text)

#Clean data
CV_Corpus=tm_map(CV_Corpus,stripWhitespace)
CV_Corpus=tm_map(CV_Corpus,removePunctuation)
CV_Corpus=tm_map(CV_Corpus,content_transformer(tolower))
CV_Corpus=tm_map(CV_Corpus,removeWords,stopwords(kind = 'en'))

#Create Term Document Matrix
dtm=TermDocumentMatrix(CV_Corpus)

#Find most frequent terms
findFreqTerms(dtm, lowfreq = 5)

#Find words associated with 'research'
findAssocs(dtm, terms = "research", corlimit = 0.7)

#Arrange terms in order of frequency
sort_cv<-sort(dtm,decreasing=TRUE)
sort_cv

#Top 10 most frequently used words
df_cv<-data.frame(word=names(sort_cv),freq=sort_cv)
head(df_cv,10)

#Create barplot
barplot(df_cv[1:10,]$freq, las = 2, names.arg = df_cv[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")              

#Create word cloud
library(wordcloud)
library(RColorBrewer)
set.seed(1234)
wordcloud(word=df_cv$word,freq=df_cv$freq,minfreq=1,scale=c(3.5,0.5), colors=brewer.pal(8,"Dark2"))



