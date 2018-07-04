require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    self.length = 0
    self.capacity = 8
    @store = StaticArray.new(self.capacity)
  end

  # O(1)
  def [](index)
    check_index(index) 
    @store[index]
  end

  # O(1)
  def []=(index, value)
    check_index(index)
    @store[index] = value
  end

  # O(1)
  def pop
    raise "index out of bounds" if length == 0
    popValue = self[self.length - 1]
    self[self.length - 1] = nil
    self.length -= 1
    popValue
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if self.capacity == self.length
    self.length += 1
    self[self.length - 1] = val
    nil
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" if self.length == 0
    
    val, self[0] = self[0], nil
    (1...self.length).each {|i| self[i - 1] = self[i]}
    self.length -= 1
    val
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    if self.length == self.capacity
      resize!
    end

    self.length += 1

    (self.length - 2).downto(0).each {|i| self[i + 1] = self[i]}

    self[0] = val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    unless index >= 0 && index < self.length
      raise "index out of bounds"
    end  
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_capacity = self.capacity * 2
    newStore = StaticArray.new(new_capacity)

    i = 0
    while i < self.length
      newStore[i] = self[i]
      i += 1
    end
    self.capacity = new_capacity
    @store = newStore
  end
end