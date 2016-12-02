#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --mem-per-cpu=1000
#SBATCH --job-name=job_reports/phase
#SBATCH --array=1-22
#SBATCH -p sysgen

# This script will take a reference-aligned binary plink file and:
# 1. For each chromosome perform shapeit phasing check
# 2. Remove snps that don't align between reference and main panel
# 3. Create a new -align plink file

# This excludes snps that don't align, however if there are a very large number
# one should go back to the qc'd plink files and make sure everything is ok
# (ie. ensure the data is in b37 format, same as the reference)

# set -e
if [ -n "${1}" ]; then
    SLURM_ARRAY_TASK_ID=${1}
fi

chr=${SLURM_ARRAY_TASK_ID}
wd=`pwd`"/"
source parameters.sh

flags="--thread 1 --noped"

#if [ "${chr}" -eq "23" ]; then
#    flags="$flags --chrX"
#fi
targetdata="test-data/DAT${chr}"

# The following step splits out variants mis-aligned between the reference and gwas panel
${shapeit2} -check \
            --input-bed ${targetdata}.bed ${targetdata}.bim ${targetdata}.fam \
            --input-map ${refgmap} \
            --input-ref ${refhaps} ${reflegend} ${refsample} \
            --output-log ${targetdatadir}${chr}

## Check the unmatched snps. If there is a problem, fix it, otherwise can use -align set.
cat ${hapdatadir}${chr}.snp.strand  | awk '$4==$8 { print $4 } ' > ${hapdatadir}${chr}.badsnps

badcount=$(wc -l ${hapdatadir}${chr}.badsnps | cut -f 1 -d ' ')
intcount=$(wc -l ${targetdata}.bim | cut -f 1 -d ' ')

echo "$badcount out of $intcount snps didn't align with reference."
plink2 --bfile ${targetdata} --exclude ${hapdatadir}${chr}.badsnps --make-bed --out ${targetdata}-align
