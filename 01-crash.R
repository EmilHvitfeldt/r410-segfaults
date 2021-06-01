res <- readr::read_rds("res.rds")
vocabulary <- readr::read_rds("vocabulary.rds")
new <- vocabulary[res]
