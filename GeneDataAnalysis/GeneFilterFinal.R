install.packages('cgdsr')
install.packages('dplyr')
install.packages('data.table')
install.packages('gridBase')
install.packages('mixexp')
                 library(cgdsr)
                 library(dplyr)
                 library(data.table)
                 library(gridBase)
                 library(mixexp)
                 
                 # Create directory for Studies results if it doesn't exist
                 dir.create(file.path("./Studies"), showWarnings = FALSE)
                 
                 # List of Genes to test for
                 inputFile <- "Sheets 1 to 6.txt"
                 conIn <- file(inputFile, open = "r")
                 mycgds = CGDS("http://www.cbioportal.org/public-portal/")
                 
                 # Test connection to cbioportal, not really necessary in the script. Just run this in R console if there are connection problems.
                 # test(mycgds)
                 
                 # Get list of caner studies
                 list<-getCancerStudies(mycgds)
                 
                 # The term to search for in the studies. Resulting files will be named [searchTerm]Studies.csv
                 searchTerm <- "Kidney"
                 file.create(paste0("./Studies/", searchTerm, "1Studies.csv"))
                 
                 # Prep the data frame for storing results
                 geneMatrix <- matrix(NA, nrow = 1, ncol = 12, dimnames=NULL)
                 geneMatrixColumns <- c('Gene', 'Publisher', 'Cancer Study', 'Total Cases', 'Total CNA Cases', 'CNA Frequency', 'Amp Frequency', 'Del Frequency', 'Total Amp Cases', 'Total Del Cases', 'Amp to CNA Ratio', 'Deletion to CNA Ratio')
                 colnames(geneMatrix )<- geneMatrixColumns
                 geneMatrix<-data.table(geneMatrix )
                 geneMatrix<-geneMatrix[-1,]
                 
                 # Match each gene with each cancer study, then get _cna case and _gistic profile.
                 # For each profile data, if getProfileData didn't return an error, do calculations.
                 # Add results to geneMatrix data frame.
                 while (length(currentGeneName <- readLines(conIn, n=1, warn = FALSE)) > 0){
                 print(paste0("Current gene: ", currentGeneName))
                 
                 for (i in 1:nrow(list)){
                 mycancername <- list[i,2]
                 if(grepl(searchTerm, mycancername)){
                 mycancerstudy <- list[i,1]
                 
                 # Get available case lists (collection of samples) for a given cancer study
                 caselist<-getCaseLists(mycgds,mycancerstudy)
                 mycaselist <- paste0(mycancerstudy, '_cna')
                 
                 # Get available genetic profiles
                 geneticprofile = getGeneticProfiles(mycgds,mycancerstudy)
                 mygeneticprofile = paste0(mycancerstudy, '_gistic')
                 
                 # Get data slices for a specified list of genes, genetic profile and case list
                 get<-getProfileData(mycgds, currentGeneName, mygeneticprofile, mycaselist)
                 if(nrow(get)>0){
                 total<-dim(get)[1]
                 totalamp<-length(which(get[,1]==2))
                 totaldel<-length(which(get[,1]==-2))
                 totalcna<-totalamp+totaldel
                 cnatotal<-round(totalcna/total*100, 2)
                 amptotal<-round(totalamp/total*100, 2)
                 deltotal<-round(totaldel/total*100, 2)
                 amptocna<-round(totalamp/totalcna*100, 2)
                 deltocna<-round(totaldel/totalcna*100, 2)
                 reseach<-cbind(currentGeneName, mycancerstudy, mycancername, total, totalcna, cnatotal, amptotal, deltotal, totalamp, totaldel, amptocna, deltocna)
                 reseach<-data.table(reseach)
                 geneMatrix <-rbind(geneMatrix , reseach)	
                 }
                 }
                 }
                 }
                 
                 # Write all the results stored in geneMatrix to the CSV file. (in the "Studies" folder)
                 write.table(geneMatrix, paste0("./Studies/", searchTerm, "Studies.csv"), append = TRUE, col.names=TRUE, sep=',', row.names=FALSE)