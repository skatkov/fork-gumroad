# frozen_string_literal: true

class Settings::BillingPolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    true
  end
end
