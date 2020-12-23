module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

# self refers to the object itself, in this case either a Car or Truck object.
# We ask self to tell us its class with .class. It tells us.
# We don't need to use to_s here because it is inside of a string and is interpolated which means it will take care of the to_s for us.