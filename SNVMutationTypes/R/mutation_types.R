#' Get mutation types
#'
#' Given a VCF file, a string representing
#' a reference genome, and an integer for the context_length,
#' it returns a vector of objects of the MutationType class.
#' Each MutationType will contain information about the mutated
#' nucleotide as well as its upstream and downstream sequences
#' (up to <context_length> nucleotides of distance from the mutated base).
#' Mutation types are obtained by allowing only C/T nucleotides
#' as the reference ones. If that was not the case in the VCF file,
#' the complementary nucleotide is considered. The same holds for the
#' upstream/downstream sequences taken from the reference genome, that
#' are reverse complemented if needed.
#'
#' Compressed VCF files are supported.
#' reference_genome has to be a string containing an
#' official genome name.
#'
#'
#' @param vcf_file A .vcf or .vcf.gz file, loaded in memory
#' @param ref_genome A reference genome. hg19, hg38 and mm10
#' are supported
#' @param context_length The number of nucleotides to retrieve
#' for the upstream and downstream sequences on ref_genome
#' @return A vector of MutationTypes
#' @export
#' @importFrom Biostrings complement DNAString getSeq reverseComplement
#' @importFrom GenomicRanges GRanges
#' @importFrom tools file_ext file_path_sans_ext
#' @importFrom VariantAnnotation expand isSNV readVcf
#' @examples
#' vcf_file <- system.file("extdata", "ex2.vcf", package="VariantAnnotation")
#' get_mutation_types(vcf_file, 'hg19', 3)
get_mutation_types <- function(vcf_file, ref_genome, context_length) {
    vcf_snv <- parse_VCF(vcf_file)
    snv_muts <- apply(vcf_snv, 1, extract_mutation)
    genome <- load_genome(ref_genome)
    mut_types <- lapply(snv_muts, get_mutation_type, genome, context_length)
}


#' Count mutation types
#'
#' Given a list of objects of class MutationType, it counts
#' the occurrences of each one of them by grouping together
#' all mutation types having the same UP, DOWN, REF and ALT
#' sequences.
#' It returns a data frame containing two columns, "MutationType"
#' and "Count".
#'
#'
#' @param mut_types A vector of MutationType objects
#' @return A dataframe containing the count of each mutation
#' type
#' @export
#' @examples
#' m1 <- MutationType(up=Biostrings::DNAString("AA"), down=Biostrings::DNAString("CC"), ref=Biostrings::DNAString("C"), alt=Biostrings::DNAString("G"))
#' m2 <- MutationType(up=Biostrings::DNAString("TA"), down=Biostrings::DNAString("GA"), ref=Biostrings::DNAString("T"), alt=Biostrings::DNAString("C"))
#' mut_types_list <- list(m1, m2)
#' count_mutation_types(mut_types_list)
count_mutation_types <- function(mut_types) {
  s <- lapply(mut_types, mutToString)
  df <- data.frame(mut_type=matrix(unlist(s), ncol = max(lengths(s)), byrow = TRUE))
  count_df <- data.frame(table(df$mut_type))
  colnames(count_df) <- c("MutationType", "Count")
  return(count_df)
}
