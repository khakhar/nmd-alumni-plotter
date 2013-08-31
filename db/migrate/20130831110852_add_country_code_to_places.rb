class AddCountryCodeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :country_code, :string
  end
end
