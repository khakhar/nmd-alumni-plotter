class RemoveCountryFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :country, :string
  end
end
