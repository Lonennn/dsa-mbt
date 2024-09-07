fn push[T](self: Stack[T], value: T) -> Stack[T] {
  Top(~value, next=self)
}

fn pop[T](self: Stack[T]) -> Stack[T] {
  match self {
    Empty => Empty
    Top(~next, ..) => next
  }
}

fn top[T](self: Stack[T]) -> Option[T] {
  match self {
    Empty => None
    Top(~value, ..) => Some(value)
  }
}

fn size[T](self: Stack[T]) -> Int {
  match self {
    Empty => 0
    Top(~next, ..) => 1 + next.size()
  }
}

test "int stack" {
  let numbers = [1, 2, 3, 4 ,5 ,6]

  let stk = numbers.fold(~init=Empty, fn(stk, it) {
    stk.push(it)
  })

  for i = numbers.length()-1, stack = stk; i >= 0; {
    assert_eq!(stack.top(), Some(numbers[i]))
    assert_eq!(stack.size(), i+1)
    continue i-1, stack.pop()
  }
}
