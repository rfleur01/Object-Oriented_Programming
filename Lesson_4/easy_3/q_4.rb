class Cat
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def to_s
    puts "I'm a #{type} cat"
  end
end