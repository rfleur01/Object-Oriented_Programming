module Nickname
  def woody
  end
end

class RodshellFleurinord
  include Nickname
end

person = RodshellFleurinord.new
person.Nickname

# A module is a collections of behaviors that are usuable in other classes
