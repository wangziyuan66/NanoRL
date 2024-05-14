#!/bin/bash
#SBATCH --job-name=hdf5                   
#SBATCH --time=24:00:00
#SBATCH --account=hongxuding
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=512gb
#SBATCH -e hdf5.err
#SBATCH -o hdf5.out


raw=./rawdata/
datasets=./analysis/datasets/
reference=./reference/
model=./analysis/iterative_label/round2/model/
path=./analysis/iterative_label/round3/
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

echo filename_fast5 | cat - $datasets/$sample/train.txt > $path/$sample/input_strand_list.txt
singularity exec $taiyaki/taiyaki.sif get_refs_from_sam.py $reference/rna.fa $path/$sample/merge.sorted.bam --reverse --output $path/$sample/train.fa
singularity exec $taiyaki/taiyaki.sif generate_per_read_params.py $raw/$sample/ --input_strand_list $path/$sample/input_strand_list.txt --jobs 256 --output $path/$sample/train.tsv
singularity exec $taiyaki/taiyaki.sif prepare_mapped_reads.py $raw/$sample/ $path/$sample/train.tsv $path/$sample/train.hdf5 $model/model_final.checkpoint $path/$sample/train.fa --input_strand_list $path/$sample/input_strand_list.txt --jobs 256 --batch_format

done

########################################################
##########          data preparation          ##########
########################################################


sbatch ./train.slurm
