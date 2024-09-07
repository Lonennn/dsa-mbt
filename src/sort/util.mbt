fn sorted[T : Compare](arr : Array[T], ~current : Int = 1) -> Bool {
  if current >= arr.length() {
    true
  } else {
    arr[current] >= arr[current - 1] && sorted(arr, current=current + 1)
  }
}

fn random_int_array(
  ~rand : @random.Rand = @random.Rand::new(),
  ~min_count : Int = 0,
  ~max_count : Int = 0x7fffff
) -> Array[Int] {
  let arr : Array[Int] = Array::new(
    capacity=rand.int(limit=max_count - min_count) + min_count,
  )
  for i = 0; i < arr.length(); i = i + 1 {
    arr[i] = rand.int()
  }
  arr
}

test "sorted" {
  assert_true!(sorted([1, 2, 3, 4, 5 ,6 ,7, 7, 7, 8, 9]))
  assert_false!(sorted([1, 3, 3, 4, 1, 2, 4]))
}