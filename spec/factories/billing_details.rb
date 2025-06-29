# frozen_string_literal: true

FactoryBot.define do
  factory :billing_detail do
    association :purchaser, factory: :user
    full_name { "John Doe" }
    business_name { "Acme Corporation" }
    business_id { "VAT123456789" }
    street_address { "123 Main Street" }
    city { "New York" }
    state { "NY" }
    zip_code { "10001" }
    country_code { "US" }
    additional_notes { "Additional billing information" }

    trait :without_business do
      business_name { nil }
      business_id { nil }
    end

    trait :non_us do
      state { nil }
      country_code { "CA" }
      zip_code { "M5V 3A8" }
      city { "Toronto" }
    end

    trait :minimal do
      business_name { nil }
      business_id { nil }
      additional_notes { nil }
    end
  end
end