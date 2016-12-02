#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --mem-per-cpu=12000
#SBATCH --job-name=imputemm3
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --array=1-22
#SBATCH -p sysgen

module load zlib/1.2.8-GCC-4.9.3
module load glibc/2.15-GCC-4.9.3

if [ -n "${1}" ]; then
    SLURM_ARRAY_TASK_ID=${1}
fi

chr=${SLURM_ARRAY_TASK_ID}

wd=`pwd`"/"
source parameters.sh
threads=8

#echo "Imputing on $threads threads"

#impute
${mm3omp} --refHaps $refvcf \
          --haps $targetvcf \
          --prefix $imputedvcf \
          --cpus $threads

#convert to plink format
plink2 --vcf ${imputedvcf}.dose.vcf.gz --make-bed --out $imputedplink --threads $threads
plink2 --bfile ${imputedplink} --hwe ${filterHWE} --maf ${filterMAF} --make-bed --out ${imputedplinkqc} --threads $threads
