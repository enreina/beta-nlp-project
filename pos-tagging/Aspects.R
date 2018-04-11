library("RDRPOSTagger")
library("tokenizers")
library("NLP")
library("stringr")
library(openNLP)
library("dplyr")
movies<-read.csv("review_train_neg.csv",header = FALSE)
tab<-table(movies$V4)
tab<-as.data.frame(tab)
tab <- tab[order(-tab$Freq),] 
tab<-factor(tab$Var1)
ind<-which((movies$V4)==as.character(tab[1]))
for(i in 2:100){
  ind<-c(ind,which((movies$V4)==as.character(tab[i])))
}
movies<-movies[ind,]
colnames(movies)<-c("Review_ID","Review","Score","Movie_ID")
movies$Movie_ID<-as.character(movies$Movie_ID)
movies$Review_ID<-as.character(movies$Review_ID)
unipostag_types <- c("EX"="Existential there","IN"="Preposition","LS"="List Marker","MD"="Modal","POS"="Possesive ending","RP"="Particle","SYM"="Symbol","TO"="to","UH"="Interjection","WP"="Pronoun","WP$"="Pronoun","WRB"="Adverb","JJ" = "adjective","JJR" = "adjective","JJS" = "adjective","CC"="conjunction","CD"="Cardinal number","DT"="Determiner","FW"="Foreign word","NN"="noun","NNP"="noun","NNS"="noun","NNPS"="noun","PDT"="Determiner","PRP"="Pronoun","PRP$"="Pronoun","RB"="Adverb","RBR"="Adverb","RBS"="Adverb","VB"="Verb","VBD"="Verb","VBG"="Verb","VBN"="Verb","VBP"="Verb","VBZ"="Verb","WDT"="Determiner")
final<-data.frame(matrix(NA, ncol = 5))
colnames(final)<-c("Movie_ID","Rev_ID","Sen_ID","Word","POS")
fullsen<-data.frame(matrix(NA, ncol = 4))
colnames(fullsen)<-c("Movie_ID","Rev_ID","Sen_ID","Sentence")

is.integer0 <- function(x)
{
  is.integer(x) && length(x) == 0L
}

tagPOS <-  function(x, ...) {
  s <- as.String(x)
  word_token_annotator <- Maxent_Word_Token_Annotator()
  a2 <- Annotation(1L, "sentence", 1L, nchar(s))
  a2 <- annotate(s, word_token_annotator, a2)
  a3 <- annotate(s, Maxent_POS_Tag_Annotator(), a2)
  a3w <- a3[a3$type == "word"]
  POStags <- unlist(lapply(a3w$features, `[[`, "POS"))
  POStagged <- paste(sprintf("%s/%s", s[a3w], POStags), collapse = " ")
  list(POStagged = POStagged, POStags = POStags)}

k=1
kk=1
for(mov in 1:nrow(movies))
{
  text <- movies[mov,]$Review
  text<-noquote(text)
  text<-as.String(text)
  text<-gsub("-", " ", text)
  text<-gsub("<br />", "", text)
  text<-gsub("\\(", "", text)
  text<-gsub(")", "", text)
  text<-gsub("\\?", ".", text)
  text<-gsub("\\s+"," ",text)
  text<-gsub("\\*","",text)
  text<-gsub("\\{","",text)
  text<-gsub("\\}","",text)
  sentences <- tokenize_sentences(text, simplify = TRUE)
  for(sen in 1:length(sentences)){
    fullsen[kk,]<-c(movies[mov,]$Movie_ID,movies[mov,]$Review_ID,sen,sentences[sen])
    kk=kk+1
    List <- strsplit(tagPOS(sentences[sen])$POStagged, " ")
    unipostags<-data.frame(matrix(NA, ncol =2,nrow=length(unlist(List))))
    colnames(unipostags)<-c("token","pos")
    unipostags$pos <- unlist(List)
    for(i in 1:nrow(unipostags)){
      ck<-strsplit(unipostags$pos, "/")[[i]][length(strsplit(unipostags$pos, "/")[[i]])]
      unipostags[i,]$token<-strsplit(unipostags$pos, paste0("/",ck),fixed = TRUE)[[i]][1]
      unipostags[i,]$pos<-ck
    }
    unipostags$pos <- unipostag_types[unipostags$pos]
    a<-grepl("noun", unipostags$pos)
    chunk = vector()
    for (i in 1:nrow(unipostags)) {
      if(i==1){
        chunk[1] = as.numeric(a[1])
      } else if(!a[i]) {
        chunk[i] = 0
      } else if (a[i] == a[i-1]) {
        chunk[i] = chunk[i-1]
      } else {
        chunk[i] = max(chunk) + 1
      }
    }
    text_chunk<-split(as.character(unipostags$token), chunk)
    tag_pattern <- split(as.character(unipostags$pos), chunk)
    names(text_chunk) <- sapply(tag_pattern, function(x) paste(x, collapse = "-"))
    res = text_chunk[grepl("noun-noun", names(text_chunk))]
    c<-NULL
    if(length(res)>0){
      for(i in 1:length(res)){
        c[i]=paste(res[[i]],collapse = " ")
      }
    }
    b<-grepl("adverb|verb", unipostags$pos)
    chunk1 = vector()
    for (i in 1:nrow(unipostags)) {
      if(i==1){
        chunk1[1] = as.numeric(b[1])
      } else if(!b[i]) {
        chunk1[i] = 0
      } else if (b[i] == b[i-1]) {
        chunk1[i] = chunk1[i-1]
      } else {
        chunk1[i] = max(chunk1) + 1
      }
    }
    text_chunk1<-split(as.character(unipostags$token), chunk1)
    tag_pattern1 <- split(as.character(unipostags$pos), chunk1)
    names(text_chunk1) <- sapply(tag_pattern1, function(x) paste(x, collapse = "-"))
    res1 = text_chunk1[grepl("adverb-verb|adverb-adverb|verb-verb", names(text_chunk1))]
    d<-NULL
    if(length(res1)>0){
      for(i in 1:length(res1)){
        d[i]=paste(res1[[i]],collapse = " ")
      }
    }
    b<-grepl("particle|adjective|adverb", unipostags$pos)
    chunk2 = vector()
    for (i in 1:nrow(unipostags)) {
      if(i==1){
        chunk2[1] = as.numeric(b[1])
      } else if(!b[i]) {
        chunk2[i] = 0
      } else if (b[i] == b[i-1]) {
        chunk2[i] = chunk2[i-1]
      } else {
        chunk2[i] = max(chunk2) + 1
      }
    }
    text_chunk2<-split(as.character(unipostags$token), chunk2)
    tag_pattern2 <- split(as.character(unipostags$pos), chunk2)
    names(text_chunk2) <- sapply(tag_pattern2, function(x) paste(x, collapse = "-"))
    res2 = text_chunk2[grepl("particle-adjective|particle-adverb-adjective", names(text_chunk2))]
    e<-NULL
    if(length(res2)>0){
      for(i in 1:length(res2)){
        e[i]=paste(res2[[i]],collapse = " ")
      }
    }
    c<-unique(c)
    d<-unique(d)
    e<-unique(e)
    ct=1  
    while(ct<=nrow(unipostags)){
      if (sum(str_count(c, paste0(unipostags[ct,1]," ",unipostags[(ct+1),1])))>0){
        final[k,]=c(movies[mov,]$Movie_ID,movies[mov,]$Review_ID,sen,c[str_detect(c, paste0(unipostags[ct,1]," ",unipostags[(ct+1),1]))],"noun")
        ct=ct+length(gregexpr(" ", c[str_detect(c, paste0(unipostags[ct,1]," ",unipostags[(ct+1),1]))])[[1]])+1
        k=k+1
      } else if (sum(str_count(d, paste0(unipostags[ct,1]," ",unipostags[(ct+1),1])))>0){
        final[k,]=c(movies[mov,]$Movie_ID,movies[mov,]$Review_ID,sen,d[str_detect(d, paste0(unipostags[ct,2]," ",unipostags[(ct+1),2]))],"verb")
        ct=ct+length(gregexpr(" ", d[str_detect(d, paste0(unipostags[ct,2]," ",unipostags[(ct+1),2]))])[[1]])+1
        k=k+1
      } else if (sum(str_count(e, paste0(unipostags[ct,1]," ",unipostags[(ct+1),1])))>0){
        final[k,]=c(movies[mov,]$Movie_ID,movies[mov,]$Review_ID,sen,e[str_detect(e, paste0(unipostags[ct,1]," ",unipostags[(ct+1),1]))],"adjective")
        ct=ct+length(gregexpr(" ", e[str_detect(e, paste0(unipostags[ct,1]," ",unipostags[(ct+1),1]))])[[1]])+1
        k=k+1
      } else{
        final[k,]=c(movies[mov,]$Movie_ID,movies[mov,]$Review_ID,sen,unipostags[ct,1],unipostags[ct,2])
        ct=ct+1
        k=k+1
      }
    }
  }
}




