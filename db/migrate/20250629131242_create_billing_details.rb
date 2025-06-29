class CreateBillingDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_details do |t|
      t.references :purchaser, null: false, foreign_key: { to_table: :users }
      t.string :full_name, null: false
      t.string :business_name
      t.string :business_id, comment: "Business tax registration ID - can store various types of tax IDs depending on country: VAT ID (EU countries), GST number (Australia, Canada, India), RFC (Mexico), ABN (Australia), CNPJ (Brazil), GB VAT (UK), or other business tax registration numbers"
      t.string :street_address, null: false
      t.string :city, null: false
      t.string :state
      t.string :zip_code, null: false
      t.string :country_code, null: false
      t.text :additional_notes

      t.timestamps
    end
  end
end
