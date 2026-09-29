///|
test "slider_field_clamp keeps values inside the range" {
  assert_eq(slider_field_clamp(5, 0, 10), 5)
  assert_eq(slider_field_clamp(0, 0, 10), 0)
  assert_eq(slider_field_clamp(10, 0, 10), 10)
  assert_eq(slider_field_clamp(-3, 0, 10), 0)
  assert_eq(slider_field_clamp(99, 0, 10), 10)
}

///|
test "slider_field_parse accepts integers and rejects junk" {
  assert_eq(slider_field_parse("120"), Some(120))
  assert_eq(slider_field_parse("-45"), Some(-45))
  assert_eq(slider_field_parse("0"), Some(0))
  assert_eq(slider_field_parse("abc"), (None : Int?))
  assert_eq(slider_field_parse(""), (None : Int?))
  assert_eq(slider_field_parse("12.5"), (None : Int?))
}

///|
test "slider_field_tick_position pins the ends, centers the middle" {
  assert_eq(slider_field_tick_position(0, 0, 7), "left:0%;transform:none")
  assert_eq(
    slider_field_tick_position(100, 6, 7),
    "left:100%;transform:translateX(-100%)",
  )
  assert_eq(
    slider_field_tick_position(50, 3, 7),
    "left:50%;transform:translateX(-50%)",
  )
  // A single tick is both first and last: it hugs the left edge.
  assert_eq(slider_field_tick_position(0, 0, 1), "left:0%;transform:none")
  assert_eq(slider_field_tick_position(0, 0, 0), "left:0%;transform:none")
}
