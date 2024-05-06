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


hdf5=./analysis/iterative_label/round3/
datasets=./analysis/datasets/ac4c/
reference=./reference/
path=./analysis/general_embed/minus_ac4c_train/
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


##singularity exec $taiyaki/taiyaki.sif /home/taiyaki/misc/merge_mappedsignalfiles.py $path/train.hdf5 --input $hdf5/canonical/train.hdf5 None --input $hdf5/hm5c/train.hdf5 None --input $hdf5/1ma/train.hdf5 None --input $hdf5/m1y/train.hdf5 None --input $hdf5/m5c/train.hdf5 None --input $hdf5/m5u/train.hdf5 None --input $hdf5/6ma/train.hdf5 None --input $hdf5/psi/train.hdf5 None --load_in_mem --batch_format

singularity exec --nv $taiyaki/taiyaki.sif train_flipflop.py $taiyaki/taiyaki_models/mLstm_flipflop.py $path/train.hdf5 --niteration 25000 --size 256 --stride 10 --winlen 31 --device cuda:0 --overwrite --outdir $path

singularity exec $taiyaki/taiyaki.sif dump_json.py $path/model_final.checkpoint --output $path/model.json

################################################
##########          training          ##########
################################################


singularity exec --nv $guppy/guppy_megalodon.sif /home/ont-guppy/bin/guppy_basecaller --input_file_list $datasets/test.txt --save_path $path --align_ref $reference/rna.fa --align_type auto --bam_out --config $reference/config.cfg --model_file $path/model.json --device cuda:0 --disable_qscore_filtering
rm $path/fastq_runid*.fastq
rm $path/guppy_basecaller_log*.log
rm $path/sequencing_telemetry.js

## guppy basecalling

singularity exec $samtools/samtools.sif samtools merge $path/merge.bam $path/bam_runid*.bam
singularity exec $samtools/samtools.sif samtools sort -o $path/merge.sorted.bam $path/merge.bam
singularity exec $samtools/samtools.sif samtools index $path/merge.sorted.bam
rm $path/bam_runid*.bam
rm $path/merge.bam

## samtools preprocessing

###################################################
##########          basecalling          ##########
###################################################

