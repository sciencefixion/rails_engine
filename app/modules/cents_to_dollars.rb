class CentsToDollars
  def self.convert(price)
    # Missing parentheses here that threw an error
    (price.to_f / 100).round(2)
  end
end
