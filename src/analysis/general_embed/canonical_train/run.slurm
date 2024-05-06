#!/bin/bash
#SBATCH --job-name=run                   
#SBATCH --time=96:00:00
#SBATCH --account=hongxuding
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=48gb
#SBATCH --gres=gpu:1
#SBATCH -e run.err
#SBATCH -o run.out


hdf5=./analysis/iterative_label/round3/canonical/
datasets=./analysis/datasets/
reference=./reference/
path=./analysis/general_embed/canonical_train/
## variables

guppy=./guppy_megalodon/
taiyaki=./taiyaki/
samtools=./samtools/
## software

echo ----------
echo setups
echo 
echo "hdf5:      "$hdf5
echo "datasets:  "$datasets
echo "reference: "$reference
echo "path:      "$path
echo ----------

## check variables

##############################################
##########          setups          ##########
##############################################


mkdir model

singularity exec --nv $taiyaki/taiyaki.sif train_flipflop.py $taiyaki/taiyaki_models/mLstm_flipflop.py $hdf5/train.hdf5 --niteration 25000 --size 256 --stride 10 --winlen 31 --device cuda:0 --overwrite --outdir $path/model/

singularity exec $taiyaki/taiyaki.sif dump_json.py $path/model/model_final.checkpoint --output $path/model/model.json

################################################
##########          training          ##########
################################################


for sample in ac4c canonical hm5c 1ma m1y m5c m5u 6ma psi; do

mkdir $sample

singularity exec --nv $guppy/guppy_megalodon.sif /home/ont-guppy/bin/guppy_basecaller --input_file_list $datasets/$sample/test.txt --save_path $path/$sample/ --align_ref $reference/rna.fa --align_type auto --bam_out --config $reference/config.cfg --model_file $path/model/model.json --device cuda:0 --disable_qscore_filtering
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

