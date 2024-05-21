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

* I ran the following populations:

	AFR

	AMR

	EAS

	EUR

	SAS

* The following seeds:

	60556

	2001

	4928

* I split the runs into separate chromosomes in the following way to be more efficient:

	1,8,9,16,17

	2,7,10,15,18

	3,6,11,14,19,22

	4,5,12,13,20,21

### PRScsx output

* Files with the following format: `Standing_height_POP_pst_eff_a1_b0.5_phiX_chr#.txt` are generated

	* POP is replaced with each population that you ran

	* X is replaced with the phi value that you used

	* The chromosome numbers correspond to the chromosome each file was generated from

* These files include the following unlabelled columns: rsid, base position, A1, A2, posterior effect size estimate 

* This data is what is used to generate individual polygenic risk scores

* They will be used as input for the All of Us Validation step

## All of Us Validation and Testing Steps

* `06_Validation.txt` to output Validation weights

* `07_Testing.text` to output Testing Adjusted R Squared Values for each pop
