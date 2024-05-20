# PRS-work

This pipeline is structured to generate polygenic risk scores with the PRS-CSx tool and test them in the All of Us Research Program dataset.
The phenotype I worked with is Standing Height

## Dependencies

* Python packages scipy and h5py

## Getting Started

* Download the GWAS summary statistics from the [Pan-UK Biobank Phenotypes page](https://pan.ukbb.broadinstitute.org/phenotypes)
 
* Run the script to add rsids to the sumstats, `00_add_rsids.sh`

* Run the script to reformat the sumstats, `01_reformat_sumstats.R`

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

### PRScsx output

* Files with the following format: `Standing_height_POP_pst_eff_a1_b0.5_phiX_chr#.txt` are generated

** POP is replaced with each population that you ran

** X is replaced with the phi value that you used

** The chromosome numbers correspond to the chromosome each file was generated from
