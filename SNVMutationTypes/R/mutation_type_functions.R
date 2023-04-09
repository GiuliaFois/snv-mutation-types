library(Biostrings)
library(GenomicRanges)
library(tools)
library(VariantAnnotation)

# Check if the parameter belongs to the expected class. If
# this is not the case, it returns an error string to be used
# by the caller
check_parameter_type <- function(param, expected_class, param_name) {
  if(!is(param, expected_class)) {
    return(paste("An object of type", expected_class, "is expected for", param_name))
  }
  else return("")
}

# Given a VCF file, it parses it, extracts SNV mutation rows
# and returns a data frame of them
#' @importClassesFrom Biostrings DNAString
parse_VCF <- function(vcf_file){
  if((msg = check_parameter_type(vcf_file, "character", "vcf_file")) != "") {
    stop(msg)
  }
  file_extension <- file_ext(vcf_file)
  file_extension_if_compressed <- file_ext(file_path_sans_ext(vcf_file))
  if(file_extension != "vcf" && file_extension_if_compressed != "vcf") {
    stop("VCF file expected")
  }
  vcf_obj <- expand(readVcf(vcf_file))
  # Extracts only rows containing SNV mutations
  snvs <- SummarizedExperiment::rowRanges(vcf_obj[isSNV(vcf_obj), ])
  as.data.frame(snvs)
}

# Given a data frame row coming from a VCF
# file and related to a SNV, it returns an object of type
# Mutation containing the chromosome, the position, the
# ref and the alt bases
extract_mutation <- function(x){
  if(x["start"] != x["end"]) {
    #It is not a SNV
    stop("start position != end position: SNV mutation expected")
  }

  Mutation(chromosome=paste0("chr", as.character(x["seqnames"])), position=as.numeric(x["start"]),
           ref=DNAString(x[["REF"]]), alt=DNAString(x[["ALT"]]))
}

# Given a Mutation object, it takes the corresponding
# upstream and downstream bases (up to a distance of context_length
# nucleotides) from the reference genome, reverse complements
# them if needed, and returns a MutationType object
get_mutation_type <- function(m, genome, context_length) {
  if((msg = check_parameter_type(m, "Mutation", "m")) != "") {
    stop(msg)
  }
  if((msg = check_parameter_type(genome, "BSgenome", "genome")) != "") {
    stop(msg)
  }
  if((msg = check_parameter_type(context_length, "numeric", "context_length")) != "") {
    stop(msg)
  }

  ref <- m@ref
  alt <- m@alt
  up_positions <- paste(m@position-context_length, m@position-1, sep="-")
  down_positions <- paste(m@position+1, m@position+context_length, sep="-")
  mutated_bp_range <- GRanges(paste(m@chromosome, m@position, "+", sep=":"))
  up_range <- GRanges(paste(m@chromosome, up_positions, "+",
                            sep=":"))
  down_range <- GRanges(paste(m@chromosome, down_positions, "+", sep=":"))
  mutated_bp_seq <- getSeq(genome, mutated_bp_range)
  up_seq <- getSeq(genome, up_range)
  down_seq <- getSeq(genome, down_range)

  if(as.character(ref) == "G" || as.character(ref) == "A") {
    ref <- complement(ref)
    alt <- complement(alt)
  }

  if(as.character(mutated_bp_seq) == "G" || as.character(mutated_bp_seq) == "A") {
    # Reverse complement and inversion of upstream and downstream sequences
    old_up_seq <- up_seq
    up_seq <- reverseComplement(down_seq)
    down_seq <- reverseComplement(old_up_seq)
  }
  MutationType(up=up_seq[[1]], down=down_seq[[1]], ref=ref, alt=alt)
}

# Since genome libraries are heavy, the specific genome is
# loaded dynamically based on the parameter
load_genome <- function(genome_name) {
  if((msg = check_parameter_type(genome_name, "character", "genome_name")) != "") {
    stop(msg)
  }
  if(genome_name == "hg38") {
    pkg <- "BSgenome.Hsapiens.UCSC.hg38"
    require(pkg, quietly = TRUE, character.only = TRUE)
    genome <- Hsapiens
  }
  else if(genome_name == "hg19") {
    pkg <- "BSgenome.Hsapiens.UCSC.hg19"
    require(pkg, quietly = TRUE, character.only = TRUE)
    genome <- Hsapiens
  }
  else if(genome_name == "mm10") {
    pkg <- "BSgenome.Mmusculus.UCSC.mm10"
    require(pkg, quietly = TRUE, character.only = TRUE)
    genome <- Mmusculus
  }
  else {
    stop(paste("The genome", genome_name, "is not supported"))
  }
  return(genome)
}
