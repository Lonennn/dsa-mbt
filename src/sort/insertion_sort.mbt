pub fn insertion_sort[T : Compare](
  arr : Array[T],
  ~begin : Int = 0,
  ~end : Int = arr.length()
) -> Unit {
  for i = begin + 1; i < end; i = i + 1 {
    let it = arr[i]
    let mut j = i
    while begin < j && arr[j - 1] > it {
      arr[j] = arr[j - 1]
      j = j - 1
    }
    arr[j] = it
  }
}

test "insertion sort ints" {
  for t = 0; t < 5000; t = t + 1 {
    let rand = @random.Rand::new()
    let arr : Array[Int] = Array::makei(rand.int(limit=1000)+1000, fn (index) {
      index |> ignore
      rand.int()
    })

    arr.shuffle_in_place(rand=fn(upper) {
      rand.int() % upper
    })
    insertion_sort(arr)
    assert_true!(sorted(arr))
  }
}
