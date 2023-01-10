# covdrop 

Pipeline for detecting primer dropout in SARS-CoV-2 tiled amplicon genomes. 

## Install

### Github

```
git clone covdrop && cd covdrop
```

```
snakemake --use-conda -j -C fasta=samples.fa bed=artic_v4.1.bed
```

### SNK

```
snk install MDU-PHL
```