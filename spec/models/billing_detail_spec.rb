require 'rails_helper'

RSpec.describe BillingDetail, type: :model do
  let(:user) { create(:user) }

  describe "validations" do
    it "requires all mandatory fields and shows validation errors when only purchaser_id is provided" do
      billing_detail = BillingDetail.new(purchaser: user)
      
      expect(billing_detail).not_to be_valid
      expect(billing_detail.errors[:full_name]).to include("can't be blank")
      expect(billing_detail.errors[:street_address]).to include("can't be blank")
      expect(billing_detail.errors[:city]).to include("can't be blank")
      expect(billing_detail.errors[:zip_code]).to include("can't be blank")
      expect(billing_detail.errors[:country_code]).to include("can't be blank")
    end

    it "successfully saves when all required fields are provided" do
      billing_detail = BillingDetail.new(
        purchaser: user,
        full_name: "John Doe",
        street_address: "123 Main St",
        city: "San Francisco",
        zip_code: "94107",
        country_code: "US",
        state: "CA"
      )
      
      expect(billing_detail).to be_valid
      expect(billing_detail.save).to be true
    end

    it "requires state when country is US" do
      billing_detail = BillingDetail.new(
        purchaser: user,
        full_name: "John Doe",
        street_address: "123 Main St",
        city: "San Francisco",
        zip_code: "94107",
        country_code: "US"
      )
      
      expect(billing_detail).not_to be_valid
      expect(billing_detail.errors[:state]).to include("can't be blank")
    end

    it "does not require state when country is not US" do
      billing_detail = BillingDetail.new(
        purchaser: user,
        full_name: "John Doe",
        street_address: "123 Main St",
        city: "London",
        zip_code: "SW1A 1AA",
        country_code: "GB"
      )
      
      expect(billing_detail).to be_valid
      expect(billing_detail.save).to be true
    end

    it "validates country_code length" do
      billing_detail = BillingDetail.new(
        purchaser: user,
        full_name: "John Doe",
        street_address: "123 Main St",
        city: "San Francisco",
        zip_code: "94107",
        country_code: "USA"
      )
      
      expect(billing_detail).not_to be_valid
      expect(billing_detail.errors[:country_code]).to include("is the wrong length (should be 2 characters)")
    end
  end
end
