# Training Data Diversity Enhances the Basecalling of Novel RNA Modification-Induced Nanopore Sequencing Readouts

## Abstract

Accurately basecalling sequence backbones in the presence of nucleotide modifications remains a substantial challenge in nanopore sequencing bioinformatics. It has been extensively demonstrated that state-of-the-art basecallers are less compatible with modification-induced sequencing signals. A precise basecalling, on the other hand, serves as the prerequisite for virtually all the downstream analyses. Here, we report that basecallers exposed to diverse training modifications gain the generalizability to analyze novel modifications. With synthesized oligos as the model system, we precisely basecall various out-of-sample RNA modifications. From the representation learning perspective, we attribute this generalizability to basecaller representation space expanded by diverse training modifications. Taken together, we conclude increasing the training data diversity as a novel paradigm for building modification-tolerant nanopore sequencing basecallers.

## Graphic Overview

<p align="center">
    <img src="https://github.com/wangziyuan66/NanoRL/blob/main/images/overview.png" width="600" height="250">
</p>

## Training Data Diversity Yields a Generalizable Basecaller Representation Space

<p align="center">
    <img src="https://github.com/wangziyuan66/NanoRL/blob/main/images/space.png" width="500" height="600">
</p>

## Table of Content

Datasets and scripts used to reproduce our results are provided here:

<pre>
./NanoRL/ ## NanoRL root folder
|-- analysis
|   |-- datasets
|   |   `-- canonical & 1ma & 6ma & ac4c & m5c & hm5c & m5u & psi & m1y ## modification groups
|   |       |-- train.txt ## training datasets
|   |       `-- test.txt ## test datasets
|   | 
|   |-- general_embed
|   |   |-- {canonical & 1ma & 6ma & ac4c & m5c & hm5c & m5u & psi & m1y}_train
|   |   |   `-- run.slurm ## individually-trained basecallers
|   |   `-- minus_{ac4c & psi & m1y}_train
|   |       `-- run.slurm ## jointly-trained basecallers
|   | 
|   `-- iterative_label
|       |-- round{0 & 1 & 2 & 3 & 4} ## iterative basecalling for precisely resolving backbone sequences
|       |   |-- basecall.slurm ## basecalling
|       |   |-- hdf5.slurm ## training data preparation
|       |   `-- train.slurm ## model training
|       |-- guppy
|       |    `-- basecall.slurm ## test data basecalling with the original guppy model
|       `-- iterate
|           `-- basecall.slurm ## test data basecalling with the final iteration model
|
|-- reference
|   |-- config.cfg ## revised guppy configuration file used during iterative basecalling
|   `-- rna.fa ## reference sequences
|
|-- guppy_megalodon
|   |-- guppy_megalodon.recipe ## recipe for creating singularity container
|   `-- guppy_models
|       `-- rna_r9.4.1_70bps_hac.cfg ## original guppy configuration file
|
|-- samtools
|   `-- samtools.recipe
|
`-- taiyaki
    |-- taiyaki_models
    |   |-- mLstm_flipflop.py ## guppy model template
    |   `-- r941_rna_minion.checkpoint ## taiyaki RNA model checkpoint
    `-- taiyaki.recipe
</pre>

## Miscellaneous

### Taiyaki

Considering **Taiyaki** has been deprecated by Oxford Nanopore Group, we provide a recipe file which could be utiled to create the [singularity sif image]([https://docs.sylabs.io/guides/3.3/user-guide/cli/singularity_sif.html](https://docs.sylabs.io/guides/3.3/user-guide/quick_start.html#overview-of-the-singularity-interface)) or [docker image](https://docs.sylabs.io/guides/2.6/user-guide/singularity_and_docker.html) in taiyaki/taiyaki.recipe.

Here is [How to build the Singularity image](https://docs.sylabs.io/guides/2.6/user-guide/build_a_container.html).

The builded image can also be downloaded in our [figshare](https://figshare.com/s/6bce33cadffb8bd8b622).

### Bonito

Download in https://github.com/nanoporetech/bonito.

### Dorado

Download in https://github.com/nanoporetech/dorado

## Citation & Contact

Ziyuan Wang: princezwang@arizona.edu
