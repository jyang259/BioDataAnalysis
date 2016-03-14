inputFile <- "Sample/SampleWords.txt"
conIn <- file(inputFile, open = "r")
outputFile <- "Sample/SampleOut.txt"
conOut <- file(outputFile, open = "w")

replacementWords <- list()
replaceWord <-'mangoes'

while (length(oneLine <- readLines(conIn, n=1, warn = FALSE)) > 0) {
  replacementWords <- c(replacementWords, oneLine)
}

for (i in 1:length(replacementWords)){
  currentWord <- replacementWords[i]
  print(currentWord)
  cat(as.character(currentWord), conOut, sep="\n")
  textX <- readLines("Sample/SampleText.txt")
  textY <- gsub(replaceWord,currentWord, textX)
  writeLines(textY, "Sample/SampleText.txt")
  replaceWord = currentWord
}

closeAllConnections()

