pub fn quick_sort[T : Compare](
  arr : Array[T],
  ~begin : Int = 0,
  ~end : Int = arr.length(),
  ~rand : @random.Rand = @random.Rand::new()
) -> Unit {
  if end - begin < 2 {
    return
  }
  let (end_of_less, begin_of_greater) = partition(arr, begin, end, rand)
  quick_sort(arr, ~begin, end=end_of_less, ~rand)
  quick_sort(arr, begin=begin_of_greater, ~end, ~rand)
}

fn partition[T : Compare](
  arr : Array[T],
  begin : Int,
  end : Int,
  rand : @random.Rand
) -> (Int, Int) {
  let mut i = begin
  let mut left = begin
  let mut right = end
  let pivot = arr[rand.int(limit=end - begin)+begin]
  while i < right {
    if arr[i] < pivot {
      arr.swap(i, left)
      i += 1
      left += 1
    } else if arr[i] > pivot {
      right -= 1
      arr.swap(i, right)
    } else {
      i += 1
    }
  }
  (left, right)
}


test "quick sort ints" {
  for t = 0; t < 100; t = t + 1 {
    let rand = @random.Rand::new()
    let arr : Array[Int] = Array::make(rand.int(limit=100000)+1000, 0)
    for i = 0; i < arr.length(); i = i + 1 {
      arr[i] = rand.int()
    }
    quick_sort(arr)
    assert_true!(sorted(arr))
  }
}
