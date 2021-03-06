class Customer <ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :merchants, through: :invoices
  validates :first_name, presence: true
  validates :last_name, presence: true
end
