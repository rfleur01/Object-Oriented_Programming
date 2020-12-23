class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer #error
tv.model #pass

Television.manufacturer #pass
Television.model #error