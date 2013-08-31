class AddCurrentToWorkPlaces < ActiveRecord::Migration
  def change
    add_column :work_places, :current, :boolean
  end
end
