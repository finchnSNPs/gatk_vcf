# make intervals

library(plyr)
library(dplyr)
library(tidyr)

####get_files()

#Generate file list. Example: get_files("*file_ending.txt")

get_files<-function(x){
	list.files(pattern = x, full.names = TRUE)
}

####readin_files()

#Generate list of data frames by applying read.table() to all. 

readin_files<-function(file_list){
	lapply(file_list,read.table,header=1)
}

####interval_maker

#Generate data frame with interval information.
#input-modified seqkit output
#output-interval lists to the specifications of GATK

interval_maker<-function(seqstats_in){
  specs<-list()
  specs[[1]]<-seqstats_in$file
  specs[[2]]<-seqstats_in$final_start
  specs[[3]]<-seqstats_in$next_kb
  specs[[4]]<-seqstats_in$final_end
  interval_dfs<-list()
  for (i in 1:nrow(seqstats_in)){
	cat("Processing:")
	cat(i)
	cat("/2303\n")
    interval_dfs[[i]]<-data.frame(format(seq(from = 1, to= specs[[2]][i], by=1000),scientific=FALSE))
    names(interval_dfs[[i]])<-"start"
    interval_dfs[[i]]$end<-format(seq(from = 1000, to= specs[[3]][i], by=1000),scientific = FALSE)
    interval_dfs[[i]]$chr<-specs[[1]][i]
    interval_dfs[[i]][interval_dfs[[i]] == specs[[3]][i]]<-specs[[4]][i]
    outname<-interval_dfs[[i]]$chr[1]
    interval_dfs[[i]]<-unite(interval_dfs[[i]],chr,start,sep=":",col="p1")
    interval_dfs[[i]]<-unite(interval_dfs[[i]],p1,end,sep="-",col="interval")
    write.table(interval_dfs[[i]],paste(outname,"1kb_intervals.txt",sep="_"),quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}

#set working directory
setwd("/gscratch/wasser/khan3/elephant_snps/data/gatk/interval_lists/seqstats")

#grab filenames from the working directory
filenames<-get_files("*_seqstats.txt")

#read in files as separate data frames
ldf<-readin_files(filenames)

#bind data frames by row (all headers must match)
seqstats<-bind_rows(ldf)

#calculate second to last position
seqstats$final_end<-seqstats$sum_len-1

#round length to next kb
seqstats$next_kb=round_any(seqstats$final_end,1000,f=ceiling)

#calculate what will be the final interval start position
seqstats$final_start<-seqstats$next_kb-999

#modify file column to show chromosome only
seqstats$file<-gsub("/gscratch/wasser/khan3/elephant_snps/data/reference/loxAfr4/loxAfr4.v2.fasta.split/loxAfr4.v2.id_","",seqstats$file)
seqstats$file<-gsub(".fasta","",seqstats$file)

#run interval_maker()
interval_maker(seqstats)

#print R specs
#sessionInfo()
