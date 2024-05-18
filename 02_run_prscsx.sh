#!/bin/bash

mydir=/home/grace/PRScsx/
#Standing height sample sizes https://docs.google.com/spreadsheets/d/1AeeADtT0U1AukliiNyiVzVRdLYPkTbruQSk38DeutU8/edit#gid=903887429
#AFR=6556, AMR=972, CSA=8657, EAS=2697, EUR=419596

pop1=afr #population
n1=6556
pop2=amr
n2=972
pop3=sas
n3=8657
pop4=eas
n4=2397
pop5=eur
n5=419596
phi=1e-2

N_THREADS=5 #adjust if server is busy (check with htop)
export MKL_NUM_THREADS=$N_THREADS
export NUMEXPR_NUM_THREADS=$N_THREADS
export OMP_NUM_THREADS=$N_THREADS


python /home/grace/PRScsx/PRScsx.py \
--ref_dir=/home/wheelerlab3/Data/PRS_LD_refs/ \
--bim_prefix=/home/wheelerlab3/2023-09-08_PRSCSx/PRSCSx_testing/METS756_merged_pre-imp_rsid_chr1-22 \
--sst_file=${mydir}gwas/standing_height_${pop1^^}_gwas.txt,${mydir}gwas/standing_height_${pop2^^}_gwas.txt,${mydir}gwas/standing_height_${pop3^^}_gwas.txt,${mydir}gwas/standing_height_${pop4^^}_gwas.txt,${mydir}gwas/standing_height_${pop5^^}_gwas.txt \
--n_gwas=$n1,$n2,$n3,$n4,$n5 \
--pop=${pop1^^},${pop2^^},${pop3^^},${pop4^^},${pop5^^} \
--phi=${phi} \
--out_dir=${mydir}output/ \
--out_name=Standing_height \
--chrom=4,5,12,13,20,21 \
--seed=60605

#to run in the bkgd, enter this on the command line:

# nohup time ./08_run_prscsx.sh > prscsx.out.a &


#--chrom=1,8,9,16,17
#--chrom=2,7,10,15,18
#--chrom=3,6,11,14,19,22
#--chrom=4,5,12,13,20,21
