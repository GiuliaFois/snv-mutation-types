test_that("returns a data frame", {
  vcf_file <- system.file("extdata", "ex2.vcf", package="VariantAnnotation")
  expect_equal(is(parse_VCF(vcf_file), "data.frame"), TRUE)
})

test_that("handles a compressed VCF file", {
  vcf_file <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
  expect_equal(is(parse_VCF(vcf_file), "data.frame"), TRUE)
})

test_that("throws error when the file does not exist", {
  not_existing_file <- "./resources/not_existing.vcf"
  expect_error(parse_VCF(not_existing_file), "*file\\(s\\) do not exist*")
})

test_that("throws error when the file doesn't have
          .vcf extension", {
  not_vcf_file <- "./not-a-vcf.txt"
  expect_error(parse_VCF(not_vcf_file), "VCF file expected")

})

test_that("throws error when the parameter isn't a string", {
  not_string <- 1234
  expect_error(parse_VCF(not_string), "An object of type character is expected for vcf_file")
})
