library(Biostrings)

#' An S4 class to represent a Mutation.
#'
#' @slot chromosome The chromosome where the mutation is located
#' @slot position The position of the mutation on the chromosome
#' @slot ref The reference base
#' @slot alt The alternative base
#' @export
#' @importClassesFrom Biostrings DNAString
#' @name Mutation-class
#' @rdname Mutation-class
#' @examples
#' Mutation(chromosome="21", position=123456789, ref=Biostrings::DNAString("C"), alt=Biostrings::DNAString("G"))
Mutation <- setClass("Mutation", slots=list(chromosome="character", position="numeric",
                                            ref="DNAString", alt="DNAString"))

#' An S4 class to represent a mutation type.
#'
#' @slot up The upstream sequence, from the reference genome
#' @slot down The downstream sequence, from the reference genome
#' @slot ref The reference base
#' @slot alt The alternative base                                                                                        ref="DNAString", alt="DNAString"))
#' @export
#' @importClassesFrom Biostrings DNAString
#' @exportClass MutationType
#' @importClassesFrom Biostrings DNAString
#' @name MutationType-class
#' @rdname MutationType-class
#' @examples
#' MutationType(up=Biostrings::DNAString("AA"), down=Biostrings::DNAString("CC"), ref=Biostrings::DNAString("C"), alt=Biostrings::DNAString("G"))
MutationType <- setClass("MutationType", slots=list(up="DNAString", down="DNAString",
                                                    ref="DNAString", alt="DNAString"))

setGeneric("mutToString", function(mt) {
  standardGeneric("mutToString")
})
setMethod(f = "mutToString",
          signature = "MutationType",
          definition = function(mt){
            str_mt <- paste(mt@up,"[",mt@ref,">",mt@alt,"]",mt@down, sep="")
            str_mt
          })
