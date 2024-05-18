#!/bin/bash
python3 /home/wheelerlab3/Data/dbSNP_annotations/cpos2rsid.py \
-i /home/grace/continuous-50-both_sexes-irnt.tsv.bgz \
-o rsids_height_gwas \
-c chr \
-ea alt \
-oa ref \
-p pos
