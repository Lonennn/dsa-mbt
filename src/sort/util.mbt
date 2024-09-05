
fn sorted[T : Compare](arr : Array[T], ~current : Int = 1) -> Bool {
  if current >= arr.length() {
    true
  } else {
    arr[current] >= arr[current - 1] && sorted(arr, current=current + 1)
  }
}