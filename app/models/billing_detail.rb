class BillingDetail < ApplicationRecord
  belongs_to :purchaser, class_name: "User"
  
  validates :full_name, :street_address, :city, :zip_code, :country_code, presence: true
  validates :state, presence: true, if: -> { country_code == "US" }
  validates :country_code, length: { is: 2 }
end
