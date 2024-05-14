# Training Data Diversity Enhances the Basecalling of Novel RNA Modification-Induced Nanopore Sequencing Readouts

Accurately basecalling sequence backbones in the presence of nucleotide modifications remains a substantial challenge in nanopore sequencing bioinformatics. It  has been extensively demonstrated that state-of-the-art basecallers are less compatible with modification-induced sequencing signals. A precise basecalling, on the other hand, serves as the prerequisite for virtually all the downstream analyses. Here, we report that basecallers exposed to diverse training modifications gain the generalizability to analyze novel modifications. With synthesized oligos as the model system, we precisely basecall various out-of-sample RNA modifications. From the representation learning perspective, we attribute this generalizability to basecaller representation space expanded by diverse training modifications. Taken together, we conclude increasing the training data diversity as a novel paradigm for building modification-tolerant nanopore sequencing basecallers.

## Tabel of Content

./NanoRL/
|-- analysis
|   |-- datasets
|   |   |-- 1ma
|   |   |-- 6ma
|   |   |-- ac4c
|   |   |-- canonical
|   |   |-- hm5c
|   |   |-- m1y
|   |   |-- m5c
|   |   |-- m5u
|   |   `-- psi
|   |-- general_embed
|   |   |-- 1ma_train
|   |   |-- 6ma_train
|   |   |-- ac4c_train
|   |   |-- canonical_train
|   |   |-- hm5c_train
|   |   |-- m1y_train
|   |   |-- m5c_train
|   |   |-- m5u_train
|   |   |-- minus_ac4c_train
|   |   |-- minus_m1y_train
|   |   |-- minus_psi_train
|   |   `-- psi_train
|   `-- iterative_label
|       |-- guppy
|       |-- iterate
|       |-- round0
|       |-- round1
|       |-- round2
|       |-- round3
|       `-- round4
|-- guppy_megalodon
|   `-- guppy_models
|-- reference
|-- samtools
`-- taiyaki
    `-- taiyaki_models

