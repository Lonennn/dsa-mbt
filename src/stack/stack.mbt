pub fn Stack::empty[T]() -> Stack[T] {
  Empty
}

pub fn Stack::from_array[T](
  arr : Array[T],
  ~begin : Int = 0,
  ~end : Int = arr.length()
) -> Stack[T] {
  for i = begin, stk = Stack::empty(); i < end; {
    continue i+1, stk.push(arr[i])
  } else {
    stk
  }
}

pub fn push[T](self : Stack[T], value : T) -> Stack[T] {
  Top(~value, next=self)
}

pub fn pop[T](self : Stack[T]) -> Stack[T] {
  match self {
    Empty => Empty
    Top(~next, ..) => next
  }
}

pub fn top[T](self : Stack[T]) -> T? {
  match self {
    Empty => None
    Top(~value, ..) => Some(value)
  }
}

pub fn size[T](self : Stack[T]) -> Int {
  match self {
    Empty => 0
    Top(~next, ..) => 1 + next.size()
  }
}

test "int stack" {
  let numbers = [1, 2, 3, 4, 5, 6]
  let stk = Stack::from_array(numbers)
  for i = numbers.length() - 1, stack = stk; i >= 0; {
    assert_eq!(stack.top(), Some(numbers[i]))
    assert_eq!(stack.size(), i + 1)
    continue i - 1, stack.pop()
  }
}
