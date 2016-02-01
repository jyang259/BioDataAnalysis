install.packages('cgdsr')
install.packages('dplyr')
install.packages('data.table')
install.packages('gridBase')
library(cgdsr)
library(dplyr)
library(data.table)
library(gridBase)
# Create CGDS object
mycgds = CGDS("http://www.cbioportal.org/public-portal/")
test(mycgds)
PRKCI <- matrix(NA, nrow = 1, ncol = 11, dimnames=NULL)
colnames(PRKCI)<-c('mycancerstudy', 'mycancername', 'total', 'totalcna', 'cnatotal', 'amptotal', 'deltotal', 'totalamp', 'totaldel', 'amptocna', 'deltocna')
PRKCI<-data.table(PRKCI)
# Get list of cancer studies at server
list<-getCancerStudies(mycgds)
for (i in 1:121){
  mycancerstudy <- list[i,1]
  mycancername<-list[i,2]
  # Get available case lists (collection of samples) for a given cancer study
  caselist<-getCaseLists(mycgds,mycancerstudy)
  mycaselist <- paste0(mycancerstudy, '_cna')
  # Get available genetic profiles
  geneticprofile = getGeneticProfiles(mycgds,mycancerstudy)
  mygeneticprofile = paste0(mycancerstudy, '_gistic')
  # Get data slices for a specified list of genes, genetic profile and case list
  get<-getProfileData(mycgds,'PRKCI', mygeneticprofile,mycaselist)
  total<-dim(get)[1]
  totalamp<-length(which(get$PRKCI==2))
  totaldel<-length(which(get$PRKCI==-2))
  totalcna<-totalamp+totaldel
  cnatotal<-round(totalcna/total*100, 2)
  amptotal<-round(totalamp/total*100, 2)
  deltotal<-round(totaldel/total*100, 2)
  amptocna<-round(totalamp/totalcna*100, 2)
  deltocna<-round(totaldel/totalcna*100, 2)
  reseach<-cbind(mycancerstudy, mycancername, total, totalcna, cnatotal, amptotal, deltotal, totalamp, totaldel, amptocna, deltocna)
  reseach<-data.table(reseach)
  PRKCI<-rbind(PRKCI, reseach)
}

write.csv(PRKCI, "CurrentGene.csv")

cancerNamesdf <- data.frame(matrix(rnorm(200),ncol=11), stringsAsFactors = FALSE)
write.csv(cancerNamesdf, "CurrentGene.csv", row.names=F)

cancerNamesdt <- fread("CurrentGene.csv", select=c(2))
head(cancerNamesdt)

for (i in 1:nrows(cancerNamesdt)){
  nameOfCancer<-cancerNamesdt[i:1]
  if(grep1("Kidney",nameOfCancer)){
    rowNumber<-i
    dataToAdd<-read.csv("CurrentGene.csv", header=TRUE)
    dataFileToAddTo<-read.csv("KidneyStudies.csv", header=TRUE)
    
    dim(dataToAdd)
    dim(dataFileToAddTo)
    
    dataFileToAddTo<-rbind(dataToAdd, dataFileToAddTo)
    dim(dataFileToAddTo)
    
    write.csv(dataFileToAddTo, "KidneyStudies.csv")
  }
}