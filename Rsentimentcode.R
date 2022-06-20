library(syuzhet)
library("tm")
library("SnowballC")
require(xlsx)

setwd("C:/Users/kelleypa.IN-PHYS-2LD169/Dropbox/Masters Report/Revised Masters Report")

###################################################   
############# STEP 1: IMPORTING ###################
################################################### 
year = 2014
yearstr <- as.character(year)
studentdata <- read.xlsx("data/studentcndata.xlsx", sheetName = yearstr)

messages <- studentdata$text

###################################################   
############# STEP 2: PREPROCESSING ###############
###################################################   

################ Text word stemming/cleaning ################
comments.eng <- messages

comments.eng <- tolower(comments.eng) #to lowercase
comments.eng <- gsub("\\d","",comments.eng) #deletes numbers
comments.eng <- gsub("","",comments.eng) #deletes apostr
comments.eng <- gsub("[[:punct:]]"," ",comments.eng) #delete punctuation
comments.eng <- gsub("[[:cntrl:]]"," ",comments.eng) #delete white space
comments.eng <- gsub("^[[:space:]]+","",comments.eng) #delete begin. space
comments.eng <- gsub("[[:space:]]+$", "",comments.eng) #delete end space

doc.list <- strsplit(as.character(comments.eng),"[[:space:]]+")

###################################################   
############# STEP 3: STOP WORDS ##################
###################################################  

################ SetUp Stopwords ################
stpwords <- read.csv("data/stopwords.txt", header=FALSE)
maskwords <- read.csv("data/maskwords.txt", header=FALSE)
colnames(stpwords) <- c("words")
colnames(maskwords) <- c("words")
#### Append all words together ####
stop_words <- NULL
stop_words <- c(as.character(stpwords$words),as.character(maskwords$words),stopwords("english"),stopwords("SMART"))

#### Create stemmed and/or stopped word eliminated list -> message #### 
message <- NULL
for (var in 1:length(doc.list)) {
  
  ### Apply Stop Words with stemming ###
  # doc.list.stemmed <- wordStem(unlist(doc.list[[var]]),language = "english")
  # doc.list.stemmed <- tm_map(Corpus(VectorSource(doc.list.stemmed)), removeWords, as.character(unlist(stop_words)))
  # message[[var]] <- matrix(doc.list.stemmed)
  
  ### Apply Stop Words without stemming ###
  doc.list.unstemmed <- tm_map(Corpus(VectorSource(unlist(doc.list[[var]]))), removeWords, as.character(unlist(stop_words)))
  message[[var]] <- matrix(doc.list.unstemmed)

}


###################################################   
############# STEP 4: SA ##########################
###################################################  

######### INITIALIZE ALL VARIABLES ###############

WORDCORPUS <- list() #filtered words from ind. posts
wordpost_list <- list() #word-lexicon matches
sentiment_list <- list() #position of sent. word match
emotion_list <- list() #position of emot. word match

positivewordhit <- list() #pos. words in post
negativewordhit <- list() #neg. words in post

wordhitcount <- 0 #numb. of word-lexicon matches


##### WORD-LEXICON MATCHES FOR EACH POST #########
for(i in 1:length(message)) {
  
  #### filter words from indiv. post #####
  x = message[[i]][1]
  if(!identical(x[[1]], character(0))){
    for(j in 1:length(x[[1]])){
      if(x[[1]][j]=="" && !is.na(x[[1]][j])){x[[1]][j]<-NA}
      }
    w <- na.omit(x[[1]])
    attributes(w)$na.action <- NULL
  } else {
    w <- NULL
  }
  
  ##### Sentiment & Emotion Analysis #####
  if(length(w)!=0){
    sentiment_w <- get_sentiment(w, method="nrc")
    emotion_w <- get_nrc_sentiment(w);
    wordpost_w <- w[as.logical(sentiment_w)]
  } else {
    sentiment_w <- ""
    positivewordhit[[i]] <- ""
    negativewordhit[[i]] <- ""
    wordpost_w <- ""
  }
  
  ###### Add to List #####
  WORDCORPUS[[i]] <- w
  wordpost_list[[i]] <- wordpost_w
  sentiment_list[[i]] <- sentiment_w
  emotion_list[[i]] <- emotion_w
  
  
  ### POSITIVE & NEGATIVE SENT. WORD LIST ###
  poshit <- ""
  neghit <- ""
  for(j in 1:length(sentiment_w)){
    if(sentiment_w[j] == 1){
      poshit <- c(poshit,w[j])
      wordhitcount <- wordhitcount+1
    }else if(sentiment_w[j] == -1){
      neghit <- c(neghit,w[j])
      wordhitcount <- wordhitcount+1
    }
  }
  # Number of Pos & Neg Words:
  positivewordhit[[i]] <- poshit
  negativewordhit[[i]] <- neghit
  
}

### All Unlisted Pos. and Neg. Words from data #####
poswordhits <- unlist(positivewordhit, recursive = TRUE)
negwordhits <- unlist(negativewordhit, recursive = TRUE)


################ COUNT SENTIMENT ##################
sentiment_matrix <- NULL
for(s in 1:length(sentiment_list)){
  if(length(sentiment_list[[s]])==1 && sentiment_list[[s]]==""){
    sentiment_matrix[s] <- 0
  } else{
    sentiment_matrix[s] <- sum(sentiment_list[[s]])
  }
}
sentiment_matrix <- as.matrix(sentiment_matrix)
colnames(sentiment_matrix) <- "totalsent" #column name

################ COUNT EMOTION ####################
emotion_matrix <- NULL
for(j in 1:length(emotion_list)){
  emot <- as.matrix(emotion_list[[j]])
  emot <- colSums(emot)
  emotion_matrix <- rbind(emotion_matrix,emot)
}
emotion_matrix <- as.matrix(emotion_matrix)
rownames(emotion_matrix) <- c() #remove row names

###################################################   
############# STEP 5: SAVING SA RESULTS ###########
###################################################  

### APPEND Sentiment TO studentdata ####
studentdata <- cbind(studentdata, sentiment_matrix)

### APPEND Emotion TO studentdata ####
studentdata <- cbind(studentdata, emotion_matrix)

###################################################

#### SAVE DATA ####
write.xlsx(studentdata,"results/studentcndataresults.xlsx", append=TRUE, sheetName = yearstr, row.names=TRUE)
