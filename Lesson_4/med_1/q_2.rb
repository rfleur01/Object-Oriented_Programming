class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end

# change attr_reader to attr_accessor, and then use the "setter" method like this: self.quantity = updated_count if updated_count >= 0.
# reference the instance variable directly within the update_quantity method, like this @quantity = updated_count if updated_count >= 0