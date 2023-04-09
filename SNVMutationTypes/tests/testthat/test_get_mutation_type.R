test_that("returns the expected object", {

  m <- Mutation(chromosome="22", position=12345667,
                ref=DNAString("C"), alt=DNAString("T"))

  getSeq_mock <- mockery::mock(Biostrings::DNAStringSet("C"), Biostrings::DNAStringSet("AAA"),
                               Biostrings::DNAStringSet("GGG"))

  with_mock(
    "SNVMutationTypes::check_parameter_type" = function(x,y,z) "",
    "SNVMutationTypes::getSeq" = getSeq_mock,
    { m_type <- get_mutation_type(m, "a_genome", 3)}
  )

  expect_equal(is(m_type, "MutationType"), TRUE)
  expect_equal(as.character(m_type@up), "AAA")
  expect_equal(as.character(m_type@down), "GGG")
  expect_equal(as.character(m_type@ref), "C")
  expect_equal(as.character(m_type@alt), "T")

})

test_that("returns the expected object with reverse complement", {

  m <- Mutation(chromosome="22", position=12345667,
                ref=DNAString("A"), alt=DNAString("C"))

  getSeq_mock <- mockery::mock(Biostrings::DNAStringSet("A"), Biostrings::DNAStringSet("ATG"),
                      Biostrings::DNAStringSet("CAT"))
  with_mock(
    "SNVMutationTypes::check_parameter_type" = function(x,y,z) "",
    "SNVMutationTypes::getSeq" = getSeq_mock,
    { m_type <- get_mutation_type(m, "a_genome", 3)}
  )

  expect_equal(is(m_type, "MutationType"), TRUE)
  expect_equal(as.character(m_type@up), "ATG")
  expect_equal(as.character(m_type@down), "CAT")
  expect_equal(as.character(m_type@ref), "T")
  expect_equal(as.character(m_type@alt), "G")
})

test_that("throws error with wrong parameter types", {
  m <- "not_mutation"

  expect_error(get_mutation_type(m, "a_genome", "An object of type mutation is expected for vcf_file"))
})
