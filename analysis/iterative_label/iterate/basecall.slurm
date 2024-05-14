#!/bin/bash
#SBATCH --job-name=basecall                   
#SBATCH --time=2:00:00
#SBATCH --account=hongxuding
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=16gb
#SBATCH --gres=gpu:1
#SBATCH -e basecall.err
#SBATCH -o basecall.out


raw=./rawdata/
datasets=./analysis/datasets/
reference=./reference/
model=./analysis/iterative_label/round3/model/
path=./analysis/iterative_label/iterate/
## variables

guppy=./guppy_megalodon/
taiyaki=./taiyaki/
samtools=./samtools/
## software

echo ----------
echo setups
echo 
echo "raw:       "$raw
echo "datasets:  "$datasets
echo "reference: "$reference
echo "model:     "$model
echo "path:      "$path
echo ----------

## check variables

##############################################
##########          setups          ##########
##############################################


for sample in ac4c canonical hm5c 1ma m1y m5c m5u 6ma psi; do

mkdir $sample

singularity exec --nv $guppy/guppy_megalodon.sif /home/ont-guppy/bin/guppy_basecaller --input_file_list $datasets/$sample/test.txt --save_path $path/$sample/ --align_ref $reference/rna.fa --align_type auto --bam_out --config $reference/config.cfg --model_file $model/model.json --device cuda:0 --disable_qscore_filtering
rm $path/$sample/fastq_runid*.fastq
rm $path/$sample/guppy_basecaller_log*.log
rm $path/$sample/sequencing_telemetry.js

## guppy basecalling

singularity exec $samtools/samtools.sif samtools merge $path/$sample/merge.bam $path/$sample/bam_runid*.bam
singularity exec $samtools/samtools.sif samtools sort -o $path/$sample/merge.sorted.bam $path/$sample/merge.bam
singularity exec $samtools/samtools.sif samtools index $path/$sample/merge.sorted.bam
rm $path/$sample/bam_runid*.bam
rm $path/$sample/merge.bam

## samtools preprocessing

done

###################################################
##########          basecalling          ##########
###################################################
