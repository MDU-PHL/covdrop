
rule plot_heatmap:
    input: 
        tsv = rules.count_Ns.output.tsv
    output:
        pdf = config['out']
    conda:
        "../envs/heatmap.yml"
    shell:
        '''
        Rscript {SCRIPT_DIR}/plot_heatmap.R -i {input} -o {output.pdf}
        '''