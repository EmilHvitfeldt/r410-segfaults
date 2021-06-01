library(textrecipes)
library(tidyverse)
kickstarter <- read_csv("kickstarter.csv.gz")

kick_rec <- recipe(~ blurb, data = kickstarter) %>%
  step_tokenize(blurb) %>%
  step_tokenfilter(blurb, max_tokens = 1e3)

kick_prep <- prep(kick_rec)

#' Above code with segfault by itself (sometimes, see line 25)
#' If you call `debugonce(table)` and press `continue`, it will crash
#' If you call `debugnoce(table)` and press `next` a lot it will not crash
#' If you call `debugonce(textrecipes:::step_tokenfilter_new)` it will crash.
#'
#' I hope that this concludes that the error happens in `table()` here:
#' https://github.com/tidymodels/textrecipes/blob/master/R/tokenfilter.R#L150
#'
#' The error only appears if the code is run in this order. Code runs correctly
#' if run in order 123 -> 9 -> 567 -> 9
#'
#' If the object that is passed to `table()` is saved to file, read back in and
#' passed to `table()`, then no error happens.
#'
#' Sometimes this code returns the following error instead:
#'
#' Error in match(levels, exclude) :
#'   'translateCharUTF8' must be called on a CHARSXP, but got 'builtin'
#'
#' with this traceback:
#'
#' 7: factor(a, exclude = exclude)
#' 6: table(unlist(get_tokens(data)), useNA = "no") at tokenfilter.R#218
#' 5: tokenfilter_fun(training[, col_names[i], drop = TRUE], x$max_times,
#'                    x$min_times, x$max_tokens, x$percentage) at tokenfilter.R#144
#' 4: prep.step_tokenfilter(x$steps[[i]], training = training, info = x$term_info)
#' 3: prep(x$steps[[i]], training = training, info = x$term_info)
#' 2: prep.recipe(kick_rec)
#' 1: prep(kick_rec)
