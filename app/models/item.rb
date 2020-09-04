class Item <ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  belongs_to :merchant
  has_many :invoice_items
  # A minor typo here from though to through
  has_many :invoices, through: :invoice_items
end
