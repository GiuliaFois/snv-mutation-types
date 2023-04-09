### SNVMutationTypes

This package was developed as part of the exam of the Scientific Programming course, taken in the 
"Bioinformatics for Computational Genomics" M.Sc. of Politecnico di Milano.

#### Introduction
The aim of this package is to expose functionalities to extract SNV mutation types from a VCF file and to summarize them into a count table.
Each mutation type provides information about the mutated base (reference and alternative form), and about the sequences upstream and downstream the mutation. These sequences are taken from a reference genome specified by the user, and have a certain length (that is a parameter as well).

#### Project structure
The package exports two functions:
* **get_mutation_types** returns a list of mutation types, given a VCF file, a reference genome name, and a parameter to specify the length of the upstream/downstream sequences. Mutation types have an internal class representation, that is the MutationType class, that contains all fields needed to store the aforementioned information (ref, alt, up, down) and has a method, *mutToString*, to obtain the "UP[REF>ALT]DOWN" string representation.
The VCF file is read and expanded, such that mutations having multiple alternative forms could be counted as a single SNV each. SNVs could be easily retrieved with the *isSNV* method of the *VariantAnnotation* package.
The reference genome is loaded dinamically based on the genome name provided by the user.
Mutation types all have C or T as their reference base. To achieve this, a reverse complement operation is performed in case of G or A bases in the VCF file or on the reference genome (in this case, the upstream and downstream sequences are swapped and reverse complemented). 
* **count_mutation_types**, given a list of mutation types, returns a count table, where the first column *MutationType* contains the string representation of each mutation type, and the second column *Count* the number of occurrences of the mutation type in question.

The unit tests are meant to make sure the private methods called by the exported functions work as expected. I tested them with simple test cases, both for success and for error cases.
Since the genome dynamic loading, requiring a retrieval achieved by connecting to the web, didn't work in the test setting, I decided to adopt a mock approach: thanks to the *mockery* package, I could specify the return values of the functions related to genome querying. This made things easier when testing the expected UP/DOWn sequences, allowing to obtain clearer comparisons.

#### Example
I now show a brief example of the usage of the package. Given that it exposes just two functions, and the whole computation is made "under the hood", it is very simple to use.

The package is loaded as
```{r}
library(SNVMutationTypes)
```

Let's prepare our data: for this example, I will load a VCF file from the VariantAnnotation package; since it is quite heavy, I copy its first 100 lines in a temporary VCF file, that I will pass to the function.
```{r}
tmp_vcf_file <- "tmp.vcf"
tmp_vcf_file_conn = file(tmp_vcf_file)
vcf_file <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
writeLines(readLines(vcf_file, 100), con=tmp_vcf_file_conn)
ref_genome <- "hg38"
context_length <- 2
```

Let's now extract the mutation types.
```{r}
mutation_types <- get_mutation_types(tmp_vcf_file, ref_genome, context_length)
```


```{r}
mut_type <- mutation_types[[3]]
mut_type
mut_type@ref
mut_type@alt
mut_type@up
mut_type@down
SNVMutationTypes:::mutToString(mut_type)
```
Let's now obtain the count table and look for mutation types with at least 3 occurrences
```{r}
mutation_types_count <- count_mutation_types(mutation_types)
mutation_types_count[mutation_types_count$Count >= 3, ]
```
