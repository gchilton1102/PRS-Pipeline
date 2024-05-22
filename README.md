# PRS-work

This pipeline is structured to generate polygenic risk scores with the PRS-CSx tool in the Pan-UK Biobank dataset and validate and test them in the All of Us Research Program dataset.
The phenotype I worked with is Standing Height.

## Dependencies

* R and Python Programming languages

* Python packages scipy and h5py

## Getting Started

* Download the GWAS summary statistics from the [Pan-UK Biobank Phenotypes page](https://pan.ukbb.broadinstitute.org/phenotypes)
 
* Run the script to add rsids to the sumstats, `00_add_rsids.sh`

* The GWAS sumstats must be in the following format to run PRScsx:
```
    SNP          A1   A2   BETA      SE
    rs4970383    C    A    -0.0064   0.0090
    rs4475691    C    T    -0.0145   0.0094
    rs13302982   A    G    -0.0232   0.0199
    ...
```

* If not already in the above format, run the script to reformat the PUKBB sumstats, `01_reformat_sumstats.R`

* Clone the PRS-CSx GitHub page

`git clone https://github.com/getian107/PRScsx.git`

* Download and extract LD Reference Panel files using the following commands:

`tar -zxvf ldblk_ukbb_afr.tar.gz`

`tar -zxvf ldblk_ukbb_amr.tar.gz`

`tar -zxvf ldblk_ukbb_eas.tar.gz`

`tar -zxvf ldblk_ukbb_eur.tar.gz`

`tar -zxvf ldblk_ukbb_sas.tar.gz`

* Download the SNP information file and put it in the same folder containing the reference panels

## Using PRS-CSx

* Run the script `02_run_prscsx.sh` with the correct population sample sizes, seed, and chromosome numbers

* You will need to edit the first part of the script that looks like this:

```
pop1=afr
n1=6556 # pop1 sample size
pop2=amr
n2=972 # pop2 sample size
pop3=sas
n3=8657 # pop3 sample size
pop4=eas
n4=2397 # pop4 sample size
pop5=eur
n5=419596 # pop5 sample size
phi=1e-04 # phi value
seed= 60556 # seed value
```

* I ran the following populations: AFR, AMR, EAS, EUR, SAS

* The following seeds: 60556, 2001, 4928

* And the following phi values: 1e-02, 1e-04, 1e-06, 1e-08

* I split the runs into separate chromosomes in the following way to be more efficient:

	1, 8, 9, 16, 17

	2, 7, 10, 15, 18

	3, 6, 11, 14, 19, 22

	4, 5, 12, 13, 20, 21

### PRScsx output

* Files with the following format: `Standing_height_POP_pst_eff_a1_b0.5_phiX_chr#.txt` are generated

	* POP is replaced with each population that you ran

	* X is replaced with the phi value that you used

	* The chromosome numbers correspond to the chromosome each file was generated from

* These files include the following unlabelled columns: rsid, base position, A1, A2, posterior effect size estimate 

* This data is what is used to generate individual polygenic risk scores

* They will be used as input for the All of Us Validation step

## All of Us Validation and Testing Steps

* Upload the PRScsx output files to your Google bucket

* This section of the pipeline is designed to be run on the All of Us Research Program server

* `03_retrieve_height_weight.html` retrieves the height and weight data for the All of Us research subjects

* `04_calc_PRS_in_AoU.html` calculates polygenic risk scores with the All of Us dataset using the weights generated with PRS-CSx

* `05_part1_compare_PRS_to_observed_join_data.html` retrieves the phenotypes and ancestry PCs of the All of Us dataset and joins this data with the calculated PRS's to create joint phenotype and PRS file: `Pan-UKB_Standing_height_PRSCSx_phiX_in_AoU_w_pheno.txt` where X is the phi value

* `06_Validation.txt` to output Validation weights

	* Use this command with the pheno file created in the previous step, the name of your desired validation weights file, and the populuations you wish to run the script with

	```
	Rscript 06_Validation.txt -f Pan-UKB_Standing_height_PRSCSx_phi1e-02_in_AoU_w_pheno.txt -v Validation_output_weights.txt -p afr,amr,eas,eur
	```

* `07_Testing.text` to output Testing Adjusted R Squared Values for each pop
