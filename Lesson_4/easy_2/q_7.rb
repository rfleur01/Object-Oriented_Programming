class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# @@cats_count is a class variable tracked at the class level
Cat.new(‘tabby’)
#<Cat:0x007fe05a0aebe0 @type=“tabby”, @age=0>
Cat.new(‘russian blue’)
#<Cat:0x007fe05a0a74d0 @type=“russian blue”, @age=0>
Cat.new(‘shorthair’)
#<Cat:0x007fe05a0a2d40 @type=“shorthair”, @age=0>