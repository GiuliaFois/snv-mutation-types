test_that("throws error when the parameter isn't a string", {
  not_string <- 1234
  expect_error(load_genome(not_string), "An object of type character is expected for genome_name")
})

test_that("throws error when the genome isn't allowed", {
  not_allowed_genome <- "sacCer3"
  expect_error(load_genome(not_allowed_genome), "The genome sacCer3 is not supported")
})
