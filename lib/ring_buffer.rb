require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    self.length = 0
    self.capacity = 8
    @store = StaticArray.new(self.capacity)
    self.start_idx = 0
  end

  # O(1)
  def [](index)
    if (index > self.length - 1)
      raise "index out of bounds"
    else  
      return @store[(self.start_idx + index) % self.capacity]
    end 
  end

  # O(1)
  def []=(index, val)
    @store[(self.start_idx + index) % self.capacity] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if self.length == 0
    popValue = self[self.length - 1]
    self[self.length - 1] = nil
    self.length -= 1
    popValue
  end

  # O(1) ammortized
  def push(val)
    if !(self.length < self.capacity)
      resize!    
    end
    self[self.length] = val
    self.length += 1
  end

  # O(1)
  def shift
    raise "index out of bounds" if self.length == 0
    temp = self[self.start_idx]
    self[self.start_idx] = nil
    p self.start_idx % 
    self.start_idx = (self.start_idx + 1) % self.capacity
    self.length -= 1
    # temp
  end

  # O(1) ammortized
  def unshift(val)
    if self.length == self.capacity
      resize!
    end
    self.start_idx = (self.start_idx - 1) % self.capacity
    self[0] = val
    self.length += 1
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    newStore = StaticArray.new(self.length * 2)
    self.capacity = self.length * 2

    i = 0
    while i < self.length
      newStore[i] = self[i]
      i += 1
    end
    @store = newStore
  end
end
