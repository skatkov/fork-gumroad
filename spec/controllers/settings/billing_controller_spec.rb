# frozen_string_literal: true

require "spec_helper"
require "shared_examples/sellers_base_controller_concern"
require "shared_examples/authorize_called"

describe Settings::BillingController do
  it_behaves_like "inherits from Sellers::BaseController"

  let(:seller) { create(:named_seller) }

  before do
    sign_in seller
  end

  it_behaves_like "authorize called for controller", Settings::BillingPolicy do
    let(:record) { :billing }
  end

  describe "GET show" do
    include_context "with user signed in as admin for seller"

    let(:pundit_user) { SellerContext.new(user: user_with_role_for_seller, seller:) }

    it "returns http success and assigns correct instance variables" do
      get :show

      expect(response).to be_successful
      expect(assigns[:react_component_props]).to eq(SettingsPresenter.new(pundit_user:).billing_props)
    end
  end

  describe "PUT update" do
    let(:billing_detail_params) do
      {
        full_name: "John Doe",
        business_name: "Acme Corp",
        business_id: "VAT123456",
        street_address: "123 Main St",
        city: "New York",
        state: "NY",
        zip_code: "10001",
        country_code: "US",
        additional_notes: "Test notes"
      }
    end

    context "when creating new billing details" do
      it "creates billing details and returns success" do
        expect {
          put :update, params: { billing_detail: billing_detail_params }, format: :json
        }.to change(BillingDetail, :count).by(1)

        expect(response.parsed_body["success"]).to be(true)
        
        billing_detail = seller.reload.billing_detail
        expect(billing_detail.full_name).to eq("John Doe")
        expect(billing_detail.business_name).to eq("Acme Corp")
        expect(billing_detail.street_address).to eq("123 Main St")
      end
    end

    context "when updating existing billing details" do
      let!(:existing_billing_detail) do
        create(:billing_detail, purchaser: seller, full_name: "Old Name")
      end

      it "updates existing billing details and returns success" do
        expect {
          put :update, params: { billing_detail: billing_detail_params }, format: :json
        }.not_to change(BillingDetail, :count)

        expect(response.parsed_body["success"]).to be(true)
        expect(existing_billing_detail.reload.full_name).to eq("John Doe")
      end
    end

    context "when validation fails" do
      let(:invalid_params) do
        { full_name: "", street_address: "", city: "", zip_code: "", country_code: "" }
      end

      it "returns error message" do
        put :update, params: { billing_detail: invalid_params }, format: :json

        expect(response.parsed_body["success"]).to be(false)
        expect(response.parsed_body["error_message"]).to be_present
      end
    end
  end
end