#!/bin/bash
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=8000
#SBATCH --array=1-22
#SBATCH -p sysgen

# This script will take a binary plink file and:

# 1. extract individual chromosomes
# 2. update genetic distance from map file
# (For the SNPs that don't have a genetic position, SHAPEIT internally
# determines its genetic position using linear interpolation)

# set -e
if [ -n "${1}" ]; then
    SLURM_ARRAY_TASK_ID=${1}
fi

chr=${SLURM_ARRAY_TASK_ID}

wd=`pwd`"/"

source parameters.sh

${plink2} --bfile ${inputdata} --chr $chr --make-bed --out ${targetdata} 
R --no-save --args ${targetdata}.bim ${refgmap} < ${genetdistR}
${plink2} --noweb --bfile ${targetdata} --make-bed --out ${targetdata} 
