pub fn AVLTree::default[K, V]() -> AVLTree[K, V] {
  Nil
}

pub fn AVLTree::emptyAVLTree[K, V]() -> AVLTree[K, V] {
  Nil
}

fn height[K, V](self : AVLTree[K, V]) -> Int {
  match self {
    Nil => 0
    Node(_, _, _, ~height) => height
  }
}

fn create[K, V](
  left : AVLTree[K, V],
  entry : Entry[K, V],
  right : AVLTree[K, V]
) -> AVLTree[K, V] {
  let hl = left.height()
  let hr = right.height()
  Node(left, entry, right, height=if hl >= hr { hl } else { hr } + 1)
}

pub fn set[K : Compare, V](
  self : AVLTree[K, V],
  entry : Entry[K, V]
) -> AVLTree[K, V] {
  match self {
    Nil => Node(Nil, entry, Nil, height=1)
    Node(left, e, right, ~height) =>
      if entry.key < e.key {
        balance(left.set(entry), e, right)
      } else if entry.key > e.key {
        balance(left, e, right.set(entry))
      } else {
        Node(left, entry, right, ~height)
      }
  }
}

pub fn remove[K : Compare, V](self : AVLTree[K, V], key : K) -> (AVLTree[K, V], Option[Entry[K, V]]) {
  match self {
    Nil => (Nil, None)
    Node(left, entry, right, ..) =>
      if key < entry.key {
        let l = left.remove(key)
        (balance(l.0, entry, right), l.1)
      } else if key > entry.key {
        let r = right.remove(key)
        (balance(left, entry, r.0), r.1)
      } else {
        try {
          let p = right.peel_max!()
          (balance(left, p.1, p.0), Some(entry))
        } catch {
          EmptyTreeError(_) => (left, Some(entry))
        }
      }
  }
}

pub fn size[K, V](self : AVLTree[K, V]) -> Int {
  match self {
    Nil => 0
    Node(left, _, right, ..) => left.size() + right.size() + 1
  }
}

pub fn containsKey[K : Compare, V](self : AVLTree[K, V], key : K) -> Bool {
  match self {
    Nil => false
    Node(left, entry, right, ..) =>
      if key < entry.key {
        left.containsKey(key)
      } else if key > entry.key {
        right.containsKey(key)
      } else {
        true
      }
  }
}

pub fn to_string[K : Show, V : Show](self : AVLTree[K, V]) -> String {
  match self {
    Nil => "Nil"
    Node(_) =>
      "AVLTree:\n" +
      "  preorder: \{self.preorder()}}\n" +
      "  inorder: \{self.inorder()}"
  }
}

fn peel_max[K : Compare, V](
  self : AVLTree[K, V]
) -> (AVLTree[K, V], Entry[K, V])!EmptyTreeError {
  match self {
    Nil => raise EmptyTreeError("Tree is empty")
    Node(l, e, r, ..) =>
      match r {
        Nil =>
          match l {
            Nil => (Nil, e)
            Node(_) => {
              let lp = l.peel_max!()
              (balance(lp.0, e, r), lp.1)
            }
          }
        Node(_) => {
          let rp = r.peel_max!()
          (balance(l, e, rp.0), rp.1)
        }
      }
  }
}

fn balance[K, V](
  left : AVLTree[K, V],
  entry : Entry[K, V],
  right : AVLTree[K, V]
) -> AVLTree[K, V] {
  let hl = left.height()
  let hr = right.height()
  if hl - hr > 1 {
    match left {
      Nil => Nil // impossible
      Node(ll, el, lr, ..) =>
        if ll.height() >= lr.height() {
          create(ll, el, create(lr, entry, right))
        } else {
          match lr {
            Nil => Nil // impossible
            Node(lrl, lre, lrr, ..) =>
              create(create(ll, el, lrl), lre, create(lrr, entry, right))
          }
        }
    }
  } else if hr - hl > 1 {
    match right {
      Nil => Nil // impossible
      Node(rl, re, rr, ..) =>
        if rr.height() >= rl.height() {
          create(create(left, entry, rl), re, rr)
        } else {
          match rl {
            Nil => Nil // impossible
            Node(rll, rle, rlr, ..) =>
              create(create(left, entry, rll), rle, create(rlr, re, rr))
          }
        }
    }
  } else {
    Node(left, entry, right, height=if hl >= hr { hl } else { hr } + 1)
  }
}

fn preorder[K : Show, V : Show](self : AVLTree[K, V]) -> String {
  match self {
    Nil => ""
    Node(left, entry, right, ..) => {
      let l = left.preorder()
      let r = right.preorder()
      if l == "" && r == "" {
        entry.to_string()
      } else if l == "" || r == "" {
        "\{entry} \{l}\{r}"
      } else {
        "\{entry} \{l} \{r}"
      }
    }
  }
}

fn inorder[K : Show, V : Show](self : AVLTree[K, V]) -> String {
  match self {
    Nil => ""
    Node(left, entry, right, ..) => {
      let l = left.inorder()
      let r = right.inorder()
      if l == "" && r == "" {
        entry.to_string()
      } else if l == "" {
        "\{entry} \{r}"
      } else if r == "" {
        "\{l} \{entry}"
      } else {
        "\{l} \{entry} \{r}"
      }
    }
  }
}

fn legal[K : Compare, V](
  self : AVLTree[K, V],
  min_key : K,
  max_key : K
) -> Bool {
  match self {
    Nil => true
    Node(left, e, right, ~height) => {
      let lh = left.height()
      let rh = right.height()
      let h = 1 + if lh > rh { lh } else { rh }
      min_key <= e.key &&
      e.key <= max_key &&
      height == h &&
      match left {
        Nil => true
        Node(_, le, _, ..) => le.key < e.key && left.legal(min_key, e.key)
      } &&
      match right {
        Nil => true
        Node(_, re, _, ..) => re.key >= e.key && right.legal(e.key, max_key)
      }
    }
  }
}

test "avl integration test" {
  let numbers = [
    "Zero",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Night",
    "Ten",
    "Eleven",
    "Twelve"
  ]
  let mut tree : AVLTree[Int, String] = AVLTree::emptyAVLTree()
  for ind, num in numbers {
    assert_false!(tree.containsKey(ind))

    tree = tree.set(Entry::make(ind, num))
    assert_eq!(ind+1, tree.size())
    assert_true!(tree.legal(0, ind))
    assert_true!(tree.containsKey(ind))

    let rm = tree.remove(ind)
    tree = rm.0
    assert_eq!(rm.1, Some(Entry::make(ind, num)))
    assert_eq!(tree.size(), ind)
    assert_true!(tree.legal(0, ind-1))

    tree = tree.set(Entry::make(ind, num))
    assert_eq!(tree.size(), ind+1)


    for j = 0; j <= ind; j = j + 1 {
      assert_true!(tree.containsKey(j))
    }
    for j = ind+1; j < numbers.length(); j = j + 1 {
      assert_false!(tree.containsKey(j))
    }
  }
}
