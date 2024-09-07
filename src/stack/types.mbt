pub enum Stack[T] {
  Empty
  Top(~value: T, ~next: Stack[T])
}