library("RDRPOSTagger")
library("tokenizers")
library("NLP")
unipostag_types <- c("ADJ" = "adjective", "ADP" = "adposition", "ADV" = "adverb", "AUX" = "auxiliary", "CCONJ" = "conjunction", "DET" = "determiner", "INTJ" = "interjection", "NOUN" = "noun", "NUM" = "numeral", "PART" = "particle", "PRON" = "pronoun", "PROPN" = "noun", "PUNCT" = "punctuation", "SCONJ" = "subordinating conjunction", "SYM" = "symbol", "VERB" = "verb", "X" = "other")
text <- "My whole family really enjoyed Peter Rabbit. We loved the music- the parodies alone were not worth the price of admission! We loved the acting and voice acting! James Corden was so great as Peter Rabbit. And we loved the laughter most of all! A fun comedy! Check out blogs and reviews to figure out if it is right for your kids. There was definitely some rude/bathroom humor- but it was not too heavy. A lot of the adult humor was very tactfully hidden. You do not need to take kids with you to laugh in this movie! It's a cute, comedy adventure! Good for the whole family! Check out our review and discussion guide at DownTheHobbitHoleBlog!"
text<-as.String(text)
sentences <- tokenize_sentences(text, simplify = TRUE)
unipostagger <- rdr_model(language = "English", annotation = "UniversalPOS")
unipostags <- rdr_pos(unipostagger, sentences)
unipostags$pos <- unipostag_types[unipostags$pos]
unipostags[unipostags$doc_id=="d2",]
for(i in 1:nrow(unipostags)){
  unipostags[i,]$doc_id=strsplit(unipostags[i,]$doc_id,"d")[[1]][2]
}
unipostags$doc_id=as.integer(unipostags$doc_id)
a<-grepl("noun", unipostags$pos)
chunk = vector()
chunk[1] = as.numeric(a[1])
for (i in 2:nrow(unipostags)) {
  
  if(!a[i]) {
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
for(i in 1:length(res)){
  c[i]=paste(res[[i]],collapse = " ")
}


b<-grepl("adverb|verb", unipostags$pos)
chunk1 = vector()
chunk1[1] = as.numeric(b[1])
for (i in 2:nrow(unipostags)) {
  
  if(!b[i]) {
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
for(i in 1:length(res1)){
  d[i]=paste(res1[[i]],collapse = " ")
}

b<-grepl("particle|adjective|adverb", unipostags$pos)
chunk2 = vector()
chunk2[1] = as.numeric(b[1])
for (i in 2:nrow(unipostags)) {
  
  if(!b[i]) {
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
for(i in 1:length(res2)){
  e[i]=paste(res2[[i]],collapse = " ")
}


is.integer0 <- function(x)
{
  is.integer(x) && length(x) == 0L
}


final<-data.frame(matrix(NA, ncol = 5))
colnames(final)<-c("Movie","Rev_ID","Sen_ID","Word","POS")
k=1
c<-unique(c)
d<-unique(d)
e<-unique(e)
for(i in unique(unipostags$doc_id)){
  j<-1
  while(j<=max(unipostags[which(unipostags$doc_id==i),]$token_id)){
    if (unipostags[which(unipostags$doc_id==i & unipostags$token_id==j),4]=="punctuation"){
      j=j+1
    } else if (sum(str_count(c, paste0(unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j)),3]," ",unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j+1)),3])))>0){
      final[k,3:5]=c(i,c[str_detect(c, paste0(unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j)),3]," ",unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j+1)),3]))],"noun")
      j=j+length(gregexpr(" ", c[str_detect(c, paste0(unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j)),3]," ",unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j+1)),3]))])[[1]])+1
      k=k+1
    } else if (sum(str_count(d, paste0(unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j)),3]," ",unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j+1)),3])))>0){
      final[k,3:5]=c(i,d[str_detect(d, paste0(unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j)),3]," ",unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j+1)),3]))],"noun")
      j=j+length(gregexpr(" ", d[str_detect(d, paste0(unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j)),3]," ",unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j+1)),3]))])[[1]])+1
      k=k+1
    } else if (sum(str_count(e, paste0(unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j)),3]," ",unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j+1)),3])))>0){
      final[k,3:5]=c(i,e[str_detect(e, paste0(unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j)),3]," ",unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j+1)),3]))],"noun")
      j=j+length(gregexpr(" ", e[str_detect(e, paste0(unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j)),3]," ",unipostags[which(unipostags$doc_id==i & unipostags$token_id==(j+1)),3]))])[[1]])+1
      k=k+1
    } else{
      final[k,3:5]=c(i,unipostags[which(unipostags$doc_id==i & unipostags$token_id==j),3],unipostags[which(unipostags$doc_id==i & unipostags$token_id==j),4])
      j=j+1
      k=k+1
    }
    
  }
}

