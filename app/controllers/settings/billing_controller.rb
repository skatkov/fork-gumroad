# frozen_string_literal: true

class Settings::BillingController < Sellers::BaseController
  before_action :authorize

  def show
    @title = "Billing"
    @react_component_props = SettingsPresenter.new(pundit_user:).billing_props
  end

  def update
    billing_detail = current_seller.billing_detail || current_seller.build_billing_detail

    if billing_detail.update(billing_detail_params)
      render json: { success: true }
    else
      render json: { success: false, error_message: billing_detail.errors.full_messages.to_sentence }
    end
  end

  private

  def billing_detail_params
    params.require(:billing_detail).permit(
      :full_name,
      :business_name,
      :business_id,
      :street_address,
      :city,
      :state,
      :zip_code,
      :country_code,
      :additional_notes
    )
  end

  def authorize
    super([:settings, :billing])
  end
end