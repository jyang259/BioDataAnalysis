replacementWords<-read.table("SampleWords.txt")

replaceWord <-'mangoes'
for (i in 1:nrow(replacementWords)){
  currentWord<-replacementWords[i,1]
  textX<-readLines("SampleText.txt")
  textY<-gsub(replaceWord,currentWord, textX)
  writeLines(textY, con="SampleText.txt")
  replaceWord=currentWord
}