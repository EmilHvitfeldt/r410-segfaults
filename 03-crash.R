# Setup
let <- expand.grid(letters, letters, letters, letters)

tokens <- paste0(let[[1]], let[[2]], let[[3]], let[[4]])

other_tokens <- c("אל")

tokens <- c(other_tokens, tokens)

set.seed(1234)
# Does not error if there isn't enough NAs
res <- sample(c(rep(NA, 1000000), tokens))

vocabulary <- setNames(seq_along(tokens), tokens)[seq_len(1000)]

# Error
new <- vocabulary[res]
