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