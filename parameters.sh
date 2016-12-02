#!/usr/bin/env bash

# Exe
######################
readonly shapeit2="bin/shapeit"
readonly mm3omp="bin/Minimac3-omp"
readonly plink2="~/bin/plink2"
readonly genetdistR="${wd}genetdist.R"

# Initial QC thresholds
######################
MAF="0.005"
HWE="0.000001"
geno="0.05"
mind="0.05"

# Filtering thresholds
######################
filterMAF="0.000001"
filterHWE="0.000001"
filtergeno="0.02"
filtermind="0.1"
filterInfo="0.3"

#Change according to data set
#############################
rawdata="${wd}data/target/dataname" 
impdata="dataname_1kg_p1v3"

#Input/Output Data
##################
inputdata="${wd}data/target/inputdata"
targetdata="${wd}data/target/DAT${chr}"
targetdatadir="${wd}data/target/"
hapdatadir="${wd}data/haplotypes/"
hapout="${hapdatadir}DAT${chr}"
targetvcf="${hapdatadir}DAT${chr}.vcf"
impdatadir="${wd}data/imputed/"
plinkimpdir="${wd}data/plink/"
imputedvcf="${wd}data/imputed/data_1kg_p1v3_${chr}"
imputedplink="${wd}data/plink/${impdata}_${chr}"
imputedplinkqc="${wd}data/plink/${impdata}_qc_${chr}"
chrdata="DAT${chr}"

#Reference Data for Phasing
###########################
refdatadir="data/reference/1000GP_Phase3/"

reflegend="${refdatadir}1000GP_Phase3_chr${chr}.legend.gz"
refhaps="${refdatadir}1000GP_Phase3_chr${chr}.hap.gz"
refsample="${refdatadir}ALL_1000G_phase1integrated_v3.sample"
refgmap="${refdatadir}genetic_map_chr${chr}_combined_b37.txt"
refsample="${refdatadir}1000GP_Phase3.sample"
#reflegend="${refdatadir}ALL_1000G_phase1integrated_v3_chr${chr}.legend.gz"
#refhaps="${refdatadir}ALL_1000G_phase1integrated_v3_chr${chr}.hap.gz"
#refsample="${refdatadir}ALL_1000G_phase1integrated_v3.sample"
#refgmap="${refdatadir}genetic_map_chr${chr}_combined_b37.txt"

#Reference Data for Imputation - m3vcf Phase1
#############################################
refdatadir="data/reference/"
refvcf="${refdatadir}${chr}.1000g.Phase3.v5.With.Parameter.Estimates.m3vcf.gz"

# shapeit2 (use reference set if less than 50 individuals)
#########################################################
minindiv=50

# minimac3 interval (default is 5Mb) (currently not used)
#########################################################
interval=5000000

# Additional directories required
####################################

mkdir -p ${targetdatadir}
mkdir -p ${hapdatadir}
mkdir -p $impdatadir
mkdir -p $plinkimpdir
