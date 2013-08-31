class AddLatitudeAndLongitudeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :latitude, :text
    add_column :places, :longitude, :text
  end
end
