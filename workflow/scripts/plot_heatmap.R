#!/usr/bin/env Rscript

################################################
################################################
## LOAD LIBRARIES                             ##
################################################
################################################

library(optparse)
library(ggplot2)
library(scales)
library(ComplexHeatmap)
library(viridis)
library(tidyverse)

################################################
################################################
## VALIDATE COMMAND-LINE PARAMETERS           ##
################################################
################################################

option_list <- list(
    make_option(c("-i", "--input_file"), type="character", default=NULL, help="Comma-separated list of mosdepth regions output file (typically end in *.regions.bed.gz)", metavar="input_files"),
    make_option(c("-o", "--output"), type="character", default="heatmap.pdf", help="Output directory", metavar="path")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

## Check input file
if (!all(file.exists(opt$input_file))) {
    stop("The input files don't exist:", call.=FALSE)
}

dat <- read.delim(opt$input_file, header=TRUE, sep='\t', stringsAsFactors=FALSE, check.names=FALSE)

## Reformat table
dat$region <- factor(dat$region, levels=unique(dat$region[order(dat$start)]))
dat$sample <- factor(dat$sample, levels=sort(unique(dat$sample)))

################################################
################################################
## REGION-BASED HEATMAP ACROSS ALL SAMPLES    ##
################################################
################################################

mat <- spread(dat[,c("sample", "region", "coverage")], sample, coverage, fill=NA, convert=FALSE)
rownames(mat) <- mat[,1]
mat <- t(as.matrix(mat[,-1])) #mat <- t(as.matrix(log10(mat[,-1] + 1)))
heatmap <-  Heatmap(mat,
                    column_title         = "Percentage of Ns per amplicon",
                    name                 = "Percent Missing",
                    cluster_rows         = TRUE,
                    cluster_columns      = FALSE,
                    show_row_names       = TRUE,
                    show_column_names    = TRUE,
                    column_title_side    = "top",
                    column_names_side    = "bottom",
                    row_names_side       = "right",
                    rect_gp              = gpar(col="white", lwd=1),
                    show_heatmap_legend  = TRUE,
                    heatmap_legend_param = list(title_gp=gpar(fontsize=12, fontface="bold"), labels_gp=gpar(fontsize=10), direction="horizontal"),
                    column_title_gp      = gpar(fontsize=14, fontface="bold"),
                    row_names_gp         = gpar(fontsize=10, fontface="bold"),
                    column_names_gp      = gpar(fontsize=10, fontface="bold"),
                    height               = unit(5, "mm")*nrow(mat),
                    width                = unit(5, "mm")*ncol(mat),
                    col                  = viridis(50))

## Size of heatmaps scaled based on matrix dimensions: https://jokergoo.github.io/ComplexHeatmap-reference/book/other-tricks.html#set-the-same-cell-size-for-different-heatmaps-with-different-dimensions
height = 0.1969*nrow(mat) + (2*1.5)
width = 0.1969*ncol(mat) + (2*1.5)
outfile <- opt$output
pdf(file=outfile, height=height, width=width)
draw(heatmap, heatmap_legend_side="bottom")
dev.off()