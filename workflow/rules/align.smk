
rule download_covid_reference:
    output:
        reference = temp("wuhCor1.fa")
    conda:
        "../envs/wget.yml"
    shell:
        '''
        wget https://hgdownload.soe.ucsc.edu/goldenPath/wuhCor1/bigZips/wuhCor1.fa.gz && gunzip wuhCor1.fa.gz
        '''


rule align:
    input:
        reference = config['reference'],
        sequences = config['fasta']
    output:
        alignment = temp("sequences.alignment")
    conda:
        "../envs/mafft.yml"
    threads:
        64
    shell:
        "mafft --thread {threads} --auto --keeplength --addfragments {input.sequences} {input.reference} > {output.alignment}"
