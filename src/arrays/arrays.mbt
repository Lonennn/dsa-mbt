pub fn copy_array[T](
  src : Array[T],
  dest : Array[T],
  ~src_begin : Int = 0,
  ~src_end : Int = src.length(),
  ~dest_begin : Int = 0
) -> Unit {
  for i = src_begin, j = dest_begin; i < src_end; i = i + 1, j = j + 1 {
    dest[i] = src[j]
  }
}

pub fn reverse[T](
  arr : Array[T],
  ~begin : Int = 0,
  ~end : Int = arr.length()
) -> Unit {
  for i = begin, j = end - 1; i < j; i = i + 1, j = j - 1 {
    arr.swap(i, j)
  }
}

pub fn shift_left[T](
  arr : Array[T],
  n : Int,
  ~begin : Int = 0,
  ~end : Int = arr.length()
) -> Unit {
  let count = end - begin
  let sh = (n % count + count) % count
  shift(arr, begin, sh, end)
}

pub fn shift_right[T](
  arr : Array[T],
  n : Int,
  ~begin : Int = 0,
  ~end : Int = arr.length()
) -> Unit {
  let count = end - begin
  let sh = count - (n % count + count) % count
  shift(arr, begin, sh, end)
}

fn shift[T](arr : Array[T], begin : Int, mid : Int, end : Int) -> Unit {
  reverse(arr, ~begin, end=mid)
  reverse(arr, begin=mid, ~end)
  reverse(arr, ~begin, ~end)
}

test "reverse ints" {
  let arr : Array[Int] = [4, 3, 2, 1]
  let cpy = arr.copy()
  reverse(arr)
  assert_eq!(arr, [1, 2, 3, 4])
  reverse(arr)
  assert_eq!(arr, cpy)
  reverse(arr)
  reverse(cpy)
  assert_eq!(arr, cpy)
  reverse(arr, begin=1, end=3)
  assert_eq!(arr, [1, 3, 2, 4])
}

test "shift" {
  let arr = [1, 2, 3, 4, 5, 6, 7]
  shift_right(arr, 2)
  inspect!(arr, content="[6, 7, 1, 2, 3, 4, 5]")
  shift_left(arr, 3)
  inspect!(arr, content="[2, 3, 4, 5, 6, 7, 1]")
}
