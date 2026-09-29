///|
test "status_badge_clamp bounds" {
  assert_eq(status_badge_clamp(45, 0, 100), 45)
  assert_eq(status_badge_clamp(-10, 0, 100), 0)
  assert_eq(status_badge_clamp(140, 0, 100), 100)
}

///|
test "status_badge_dash scales percent to arc length" {
  assert_eq(status_badge_dash(0), 0.0)
  assert_eq(status_badge_dash(100), 94.2478)
  // 50% sits at half the circumference
  assert_eq((status_badge_dash(50) * 10000.0).to_int(), 471239)
  // out-of-range input clamps instead of overflowing the circle
  assert_eq(status_badge_dash(250), 94.2478)
}

///|
test "status_badge_count_label caps at two digits" {
  assert_eq(status_badge_count_label(1), "1")
  assert_eq(status_badge_count_label(99), "99")
  assert_eq(status_badge_count_label(120), "99")
  assert_eq(status_badge_count_label(-3), "0")
}
