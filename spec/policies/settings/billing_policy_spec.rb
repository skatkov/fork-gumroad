# frozen_string_literal: true

require "spec_helper"

describe Settings::BillingPolicy do
  subject { described_class }

  let(:user) { create(:user) }
  let(:seller) { create(:named_seller) }

  permissions :show? do
    it "grants access to any user" do
      expect(subject).to permit(SellerContext.new(user:, seller:), nil)
    end
  end

  permissions :update? do
    it "grants access to any user" do
      expect(subject).to permit(SellerContext.new(user:, seller:), nil)
    end
  end
end