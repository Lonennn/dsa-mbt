pub fn merge_sort[T : Compare](
  arr : Array[T],
  ~begin : Int = 0,
  ~end : Int = arr.length(),
  ~buffer : Array[T] = Array::new(capacity=arr.length() / 2)
) -> Unit {
  if end - begin < 2 {
    return
  }
  let mid = (end + begin) / 2
  merge_sort(arr, ~begin, end=mid, ~buffer)
  merge_sort(arr, begin=mid, ~end, ~buffer)
  @arrays.copy_array(arr, buffer, src_begin=begin, src_end=mid)
  let mut i = 0
  let mut j = mid
  let i_end = mid - begin
  let mut k = 0
  while i < i_end && j < end {
    if arr[j] < buffer[i] {
      arr[k] = arr[j]
      j += 1
    } else {
      arr[k] = buffer[i]
      i += 1
    }
    k += 1
  }
  @arrays.copy_array(buffer, arr, src_begin=i, src_end=i_end)
}

test "merge sort int" {
  let rand = @random.Rand::new()
  for t = 0; t < 500; t = t + 1 {
    let arr = random_int_array(~rand, min_count=5000, max_count=100000)
    merge_sort(arr)
    assert_true!(sorted(arr))
  }
}
