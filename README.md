# Training Data Diversity Enhances the Basecalling of Novel RNA Modification-Induced Nanopore Sequencing Readouts

Accurately basecalling sequence backbones in the presence of nucleotide modifications remains a substantial challenge in nanopore sequencing bioinformatics. It has been extensively demonstrated that state-of-the-art basecallers are less compatible with modification-induced sequencing signals. A precise basecalling, on the other hand, serves as the prerequisite for virtually all the downstream analyses. Here, we report that basecallers exposed to diverse training modifications gain the generalizability to analyze novel modifications. With synthesized oligos as the model system, we precisely basecall various out-of-sample RNA modifications. From the representation learning perspective, we attribute this generalizability to basecaller representation space expanded by diverse training modifications. Taken together, we conclude increasing the training data diversity as a novel paradigm for building modification-tolerant nanopore sequencing basecallers.

## Tabel of Content

<pre>
./NanoRL/
|-- analysis
|   |-- datasets
|   |   `-- canonical & 1ma & 6ma & ac4c & m5c & hm5c & m5u & psi & m1y ## modification groups
|   |       |-- train.txt ## training datasets
|   |       `-- test.txt ## test datasets used
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
|   |-- config.cfg ## the guppy configuration file using during iterative basecalling
|   `-- rna.fa ## reference sequences
|
|-- guppy_megalodon
|   |-- guppy_megalodon.recipe ## recipe for creating singularity container
|   `-- guppy_models
|       `-- rna_r9.4.1_70bps_hac.cfg ## the original guppy configuration file
|
|-- samtools
|   `-- samtools.recipe
|
`-- taiyaki
    |-- taiyaki_models
    |   |-- mLstm_flipflop.py ## model template
    |   `-- r941_rna_minion.checkpoint ## taiyaki RNA model checkpoint
    `-- taiyaki.recipe
</pre>

