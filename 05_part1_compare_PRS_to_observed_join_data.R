#paste function to concatenate filenames/paths
library(data.table)
library(tidyverse)  # Data wrangling packages.
"%&%" = function(a,b) paste(a,b,sep="")

#retrieve phenotypes from bucket and read in
#name_of_file_in_bucket <- 'height_weight_demog_2023-09-27.txt'
name_of_file_in_bucket <- 'height_weight_demog_2023-12-04.txt'
########################################################################
##
################# DON'T CHANGE FROM HERE ###############################
##
########################################################################

# Get the bucket name
my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# Copy the file from current workspace to the bucket
system(paste0("gsutil cp ", my_bucket, "/data/", name_of_file_in_bucket, " ."), intern=T)

# Load the file into a dataframe
pheno  <- fread(name_of_file_in_bucket)

# Copy the scores into the workspace bucket
system("gsutil -u $GOOGLE_PROJECT cp -r gs://fc-secure-0b5d7336-c242-426a-8854-548d4ed254d8/data/scores .")

#retrieve ancestry PCs from bucket and read in
system("gsutil -u $GOOGLE_PROJECT cp gs://fc-aou-datasets-controlled/v7/wgs/short_read/snpindel/aux/ancestry/ancestry_preds.tsv .")
ancestry = fread("ancestry_preds.tsv")

#make dataframe of just IDs and PCs
#first remove square brackets in pca_features w/substr 
ancestry2 <- mutate(ancestry, pca_features=substr(pca_features,2,nchar(pca_features)-1))
#then split on commas 
pcs <-str_split_fixed(ancestry2$pca_features, ',', 16)

#convert characters (chr) to numeric (dbl) type and add id's
pcs <- matrix(as.numeric(pcs),ncol=16)
rownames(pcs) <- ancestry$research_id
#make a data.frame for later joining, add predicted genetic ancestry
pc_df <- as.data.frame(pcs) |> mutate(research_id=rownames(pcs),ancestry_pred_other=ancestry$ancestry_pred_other)

#Read and combine PRS's (add up chr scores per population)
scoredir="scores/"
n=245394 #number of people in .sscore files (from system call above)
#make matrix to add each pop's PRS to
all_prs = matrix(nrow=n,ncol=5) #people x #pops
pops = c("AFR","AMR","EAS","EUR","SAS")
for(i in 1:length(pops)){
  pop = pops[i]
  #make matrix to add each chr's score to
  prs = matrix(nrow=n,ncol=22) # #people x #chromosomes
  #load matrix
  for(j in 1:22){
    #read in scores calculated in AoU (these were trained in Pan-UKB with SNPs in METS756 .bim file)
    scores = fread(scoredir %&% "Standing_height_" %&% pop %&% "_pst_eff_a1_b0.5_phi1e-02_chr" %&% j %&% ".sscore")
    prs[,j] = scores$SCORE1_AVG
  }
  sum_prs = scale(rowSums(prs)) #take the sum of each row and scale (mean=0,var=1) to generate final PRS
  #add to pop matrix
  all_prs[,i] = sum_prs
  #add sample IID's as rownames
  rownames(all_prs) = scores$`#IID`
  #add pops as colnames
  colnames(all_prs) = pops
}

#join height PRS's with ancestry PCs
prs_df = data.frame(all_prs) |> mutate(research_id=rownames(all_prs))
prs_pcs = inner_join(prs_df,pc_df,by='research_id')

#join PRS and PCs w/phenotypes
#need person_id in pheno to be characters
pheno = mutate(pheno,research_id=as.character(person_id))
all_data = inner_join(prs_pcs,pheno,by='research_id')

#write all_data to text file.
fwrite(all_data,"Pan-UKB_Standing_height_PRSCSx_phi1e-02_in_AoU_w_pheno.txt",quote=F,row.names=F,sep='\t')
#cp to bucket
system("gsutil -m cp Pan-UKB_Standing_height_PRSCSx_phi1e-02_in_AoU_w_pheno.txt ${WORKSPACE_BUCKET}/data/")

