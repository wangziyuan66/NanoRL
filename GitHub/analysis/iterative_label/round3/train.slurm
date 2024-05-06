#!/bin/bash
#SBATCH --job-name=train                   
#SBATCH --time=96:00:00
#SBATCH --account=hongxuding
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=48gb
#SBATCH --gres=gpu:1
#SBATCH -e train.err
#SBATCH -o train.out


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


mkdir model

singularity exec $taiyaki/taiyaki.sif /home/taiyaki/misc/merge_mappedsignalfiles.py $path/model/train.hdf5 --input $path/ac4c/train.hdf5 None --input $path/canonical/train.hdf5 None --input $path/hm5c/train.hdf5 None --input $path/1ma/train.hdf5 None --input $path/m1y/train.hdf5 None --input $path/m5c/train.hdf5 None --input $path/m5u/train.hdf5 None --input $path/6ma/train.hdf5 None --input $path/psi/train.hdf5 None --load_in_mem --batch_format

singularity exec --nv $taiyaki/taiyaki.sif train_flipflop.py $taiyaki/taiyaki_models/mLstm_flipflop.py $path/model/train.hdf5 --niteration 25000 --size 256 --stride 10 --winlen 31 --device cuda:0 --overwrite --outdir $path/model/

singularity exec $taiyaki/taiyaki.sif dump_json.py $path/model/model_final.checkpoint --output $path/model/model.json

################################################
##########          training          ##########
################################################

