class CreateWorkPlaces < ActiveRecord::Migration
  def change
    create_table :work_places do |t|
      t.integer :place_id
      t.integer :organisation_id
      t.integer :engagement_type_id

      t.timestamps
    end
  end
end
