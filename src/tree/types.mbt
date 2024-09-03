
struct Entry[K, V] {
  key: K
  value: V
}

pub enum AVLTree[K, V] {
  Nil
  Node(AVLTree[K, V], Entry[K ,V], AVLTree[K, V], ~height: Int)
}

type! EmptyTreeError String