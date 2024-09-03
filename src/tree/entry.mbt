pub fn Entry::make[K, V](key: K, value: V) -> Entry[K, V] {
  Entry::{
    key: key,
    value: value
  }
}

pub fn op_equal[K : Eq, V : Eq](self: Entry[K, V], other: Entry[K, V]) -> Bool {
  self.key == other.key && self.value == other.value
}

pub fn output[K : Show, V : Show](self: Entry[K, V], logger: Logger) -> Unit {
  logger.write_string("Entry{key: \{self.key}, value: \{self.value}}")
}

pub fn to_string[K : Show, V : Show](self: Entry[K, V]) -> String {  
  let logger = Buffer::new()
  self.output(logger)
  logger.to_string()
}

// pub impl Show for Entry[Show, Show] with output(self, logger) -> Unit {

// }

