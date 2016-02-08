replacementWords<-file('SampleWords.txt' ,'r')
outfile<-file('SampleOut.txt', 'w')
replaceWord <-'mangoes'
while (length(input<-readLines(replacementWords,n=-1)>0)){
  for (i in 1:length(input)){
    print(i) 
    currentWord<-input[i,1]
    writeLines(text=currentWord, con=outfile, sep="\n")
    textX<-readLines("SampleText.txt")
    textY<-gsub(replaceWord,currentWord, textX)
    writeLines(textY, con="SampleText.txt")
    replaceWord=currentWord
  }
}