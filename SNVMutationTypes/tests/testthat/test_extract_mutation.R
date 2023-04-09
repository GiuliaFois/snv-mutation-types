test_that("returns a mutation", {
  vcf_file <- system.file("extdata", "ex2.vcf", package="VariantAnnotation")
  vcf_df <- parse_VCF(vcf_file)
  test_df_row <- vcf_df[1,]
  mutation <- extract_mutation(test_df_row)
  expect_equal(is(mutation, "Mutation"), TRUE)
  expect_equal(mutation@chromosome, paste0("chr", test_df_row["seqnames"], sep=""))
  expect_equal(mutation@position, as.numeric(test_df_row["start"]))
  expect_equal(mutation@ref, DNAString(test_df_row$REF))
  expect_equal(mutation@alt, DNAString(test_df_row$ALT))
})

test_that("throws error when start position != end position", {
  vcf_file <- system.file("extdata", "ex2.vcf", package="VariantAnnotation")
  vcf_df <- parse_VCF(vcf_file)
  test_df_row <- vcf_df[1,]
  test_df_row$start <- test_df_row$end + 1
  expect_error(extract_mutation(test_df_row), "start position != end position: SNV mutation expected")
})



