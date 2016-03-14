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

cancerNamesdf <- data.frame(matrix(rnorm(220),ncol=11), stringsAsFactors = FALSE)
write.csv(cancerNamesdf, "CurrentGene.csv", row.names=F)

cancerNamesdt <- fread("PRKCI.csv", select=c(3))
head(cancerNamesdt)

studyHeaders <-read.table("PRKCI.csv", nrows=1, sep=',', header=TRUE, stringsAsFactors=FALSE)
studyHeaders = studyHeaders[-1,]
write.csv(studyHeaders, "KidneyStudies.csv", row.names=FALSE)

for (i in 2:nrow(cancerNamesdt)){
  nameOfCancer<-cancerNamesdt[i]
  cat(i);
  print(nameOfCancer);
  if(grepl("Kidney",nameOfCancer)){
    rowNumber<-i
    dataToAdd <-read.csv("PRKCI.csv", nrows=1, skip=(i-1), header=TRUE)
    print("boo");
    
    write.table(dataToAdd, "KidneyStudies.csv", append = TRUE, col.names=!file.exists("PRKCI.csv"), sep=',', row.names=FALSE)
    #write.csv(dataToAdd, "KidneyStudies.csv", append=TRUE, )
  }
}