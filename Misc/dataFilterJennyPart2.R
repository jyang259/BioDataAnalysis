inputFile <- "GeneList2.txt"
conIn <- file(inputFile, open = "r")
outputFile <- "SampleOut.txt"
conOut <- file(outputFile, open = "w")

replacementWords <- list()
replaceWord <-'ANKRD26P1'

while (length(oneLine <- readLines(conIn, n=1, warn = FALSE)) > 0) {
  replacementWords <- c(replacementWords, oneLine)
}

for (i in 1:length(replacementWords)){
  print(i) 
  currentWord <- replacementWords[i]
  print(currentWord)
  cat(as.character(currentWord), conOut, sep="\n")
  textX <- readLines("DataFilterJenny.txt")
  textY <- gsub(replaceWord,currentWord, textX)
  writeLines(textY, "DataFilterJenny.txt")
  source("DataFilterJenny")
  replaceWord = currentWord
}

closeAllConnections()



geneList<- read.table("GeneList.txt", header=TRUE)

source("DataFilterJenny.txt")

replace=PRKCI
for(i in 2:nrows(geneList)){
	x<-readLines(DataFilterJenny)
	y<-gsub("replace","i", x)
	cat(y, file=DataFilterJenny, sep="\n")
	source("DataFilterJenny")
	replace=i
}