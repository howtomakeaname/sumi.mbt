///|
test "slider_percent maps the range onto 0-100" {
  assert_eq(slider_percent(0, 0, 100), 0)
  assert_eq(slider_percent(50, 0, 100), 50)
  assert_eq(slider_percent(100, 0, 100), 100)
  assert_eq(slider_percent(90, 0, 180), 50)
}

///|
test "slider_percent clamps out-of-range values" {
  assert_eq(slider_percent(-10, 0, 100), 0)
  assert_eq(slider_percent(110, 0, 100), 100)
  assert_eq(slider_percent(5, 10, 20), 0)
}

///|
test "slider_percent degenerates to 0 on an empty range" {
  assert_eq(slider_percent(5, 5, 5), 0)
  assert_eq(slider_percent(5, 10, 5), 0)
}
