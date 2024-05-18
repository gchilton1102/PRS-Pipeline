#Reformatting the GWAS summary statistics
#alt is effect allele
library("dplyr")
library("data.table")
"%&%" = function(a,b) paste(a,b,sep="")
main <- function() {
  "%&%" = function(a,b) paste(a,b,sep="")
	args <- commandArgs(trailingOnly = TRUE)
	pop <- args[1]
	sum_stats <- args[-1]
	beta_col <- "beta_"%&%pop
	se_col <- "se_"%&%pop
	message("Reformatting "%&%pop)
	data <- fread(sum_stats)
	reformatted <- select(data, rsid,ref,alt,beta_col,se_col)
	reformatted <- rename(reformatted, SNP=rsid, A1=alt, A2=ref,BETA=beta_col, SE=se_col)
	fwrite(reformatted, file="/home/grace/PRScsx/gwas/"%&%pop%&%"_height_gwas.csv",append=FALSE)
	}
main()
