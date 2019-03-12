pragma solidity 0.5.0;

library IterableMap {
  struct Map
  {
    mapping(bytes32 => Value) values;
    Key[] keys;
    uint N;
  }

  struct Value {
    uint keyIndex;
    uint value;
  }

  struct Key {
    bytes32 key;
    bool deleted;
  }

  function insert(Map storage self, bytes32 key, uint value) public returns (bool isNew)
  {
    uint keyIndex = self.values[key].keyIndex;
    self.values[key].value = value;
    if (keyIndex > 0) {
        return false;
    } else {
      keyIndex = self.keys.length++;
      self.values[key].keyIndex = keyIndex + 1;

      self.keys[keyIndex].key = key;
      self.keys[keyIndex].deleted = false;

      self.N++;
      return true;
    }
  }

  function remove(Map storage self, bytes32 key) public returns (bool success)
  {
    uint keyIndex = self.values[key].keyIndex;
    if (keyIndex == 0)
      return false;
    delete self.values[key];
    self.keys[keyIndex - 1].deleted = true;
    self.N--;
    return true;
  }

  function contains(Map storage self, bytes32 key) public view returns (bool) {
    return self.values[key].keyIndex > 0;
  }

  function first(Map storage self) public view returns (uint keyIndex) {
    return next(self, uint(-1));
  }

  function valid(Map storage self, uint keyIndex) public view returns (bool) {
    return keyIndex < self.keys.length;
  }

  function next(Map storage self, uint keyIndex) public view returns (uint _keyIndex) {
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }

  function getValue(Map storage self, uint keyIndex) public view returns (bytes32 key, uint value) {
    /* if (self.keys[keyIndex].deleted) return (0,0); */
    key = self.keys[keyIndex].key;
    value = self.values[key].value;
  }

  function size(Map storage self) public view returns (uint) {
    return self.N;
  }
}
