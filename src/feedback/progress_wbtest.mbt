///|
test "progress_percent maps value onto 0-100" {
  assert_eq(progress_percent(0, 100), 0)
  assert_eq(progress_percent(1, 2), 50)
  assert_eq(progress_percent(3, 4), 75)
  assert_eq(progress_percent(100, 100), 100)
}

///|
test "progress_percent clamps and survives bad input" {
  assert_eq(progress_percent(-5, 100), 0)
  assert_eq(progress_percent(150, 100), 100)
  assert_eq(progress_percent(1, 0), 0)
  assert_eq(progress_percent(1, -2), 0)
}
