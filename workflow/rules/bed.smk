
rule collapse_primer_bed:
    input:
        primer_bed_file = config['bed']
    output:
        collapsed_primer_bed_file = temp("amplicons.bed")
    conda:
        "../envs/base.yml"
    shell:
        '''
        python {SCRIPT_DIR}/collapse_primer_bed.py {input} {output}
        '''

rule count_Ns:
    input:
        regions = rules.collapse_primer_bed.output.collapsed_primer_bed_file,
        fasta = rules.align.output.alignment
    output:
        tsv = temp("Ns.tsv")
    conda:
        "../envs/base.yml"
    shell:
        '''
        python {SCRIPT_DIR}/count_Ns.py {input.fasta} {output} -r {input.regions}
        '''

