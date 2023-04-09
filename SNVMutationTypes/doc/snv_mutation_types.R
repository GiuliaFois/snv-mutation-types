## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE) 

## -----------------------------------------------------------------------------
library(SNVMutationTypes)

## -----------------------------------------------------------------------------
tmp_vcf_file <- "tmp.vcf"
tmp_vcf_file_conn = file(tmp_vcf_file)
vcf_file <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
writeLines(readLines(vcf_file, 100), con=tmp_vcf_file_conn)
ref_genome <- "hg38"
context_length <- 2

## -----------------------------------------------------------------------------
mutation_types <- get_mutation_types(tmp_vcf_file, ref_genome, context_length)

## -----------------------------------------------------------------------------
mut_type <- mutation_types[[3]]
mut_type
mut_type@ref
mut_type@alt
mut_type@up
mut_type@down
SNVMutationTypes:::mutToString(mut_type)

## -----------------------------------------------------------------------------
mutation_types_count <- count_mutation_types(mutation_types)
mutation_types_count[mutation_types_count$Count >= 3, ]

