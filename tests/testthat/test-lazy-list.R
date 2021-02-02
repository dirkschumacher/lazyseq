test_that("basic stuff works", {
  y <- 10
  z <- 42
  expect_silent(x <- lazy_list(print(1), print(2), y, !!z))
  res1 <- expect_silent(x[[3]])
  res2 <- expect_silent(x[[4]])
  expect_equal(res1, y)
  expect_equal(res2, z)
})

test_that("does not support named arguments", {
  expect_error(lazy_list(a = 10))
})

test_that("slicing works", {
  x <- lazy_list(print(1), print(2), 3)
  expect_equal(length(x), 3)
  x <- x[3]
  expect_true(is_lazy_list(x))
  expect_equal(length(x), 1)
  expect_equal(x[[1]], 3)
})

test_that("we can cast to list", {
  x <- as.list(lazy_list(1, (function() 42)(), 3))
  expect_true(is_list(x))
  expect_equal(x, list(1, 42, 3))
})

test_that("materialize on casting to list", {
  x <- lazy_list(1, (function() 42)())
  expect_equal(
    vec_c(x, list(4)), list(1, 42, 4)
  )
  expect_equal(
    vec_c(list(1), x), list(1, 1, 42)
  )
  expect_equal(
    vec_cast(x, list()), list(1, 42)
  )
  expect_equal(
    vec_cast(x, lazy_list()), x
  )
})

test_that("concat lazy_lists is lazy", {
  res <- vec_c(lazy_list(1), lazy_list(2))
  expect_true(is_lazy_list(res))
})

test_that("format does not materialize", {
  res <- lazy_list(stop(1), stop(2), stop(3))
  expect_silent(res <- capture.output(print(res)))
  expect_equal(res, "<lazy_list[3]>")
})

test_that("abbr name is correct", {
  expect_equal(vec_ptype_abbr(lazy_list()), "lazy_list")
})

test_that("assigning non-quosures converts to quosures", {
  x <- lazy_list(print(1))
  x[[1]] <- 10
  expect_equal(x[[1]], 10)
})
