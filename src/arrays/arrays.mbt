pub fn copy_array[T](
  src : Array[T],
  dest : Array[T],
  ~src_begin : Int = 0,
  ~src_end : Int = src.length(),
  ~dest_begin: Int = 0
) -> Unit {
  for i = src_begin, j = dest_begin;  i < src_end; i = i + 1, j = j + 1 {
    dest[i] = src[j]
  }
}
