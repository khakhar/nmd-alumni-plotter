class CreateExpertiseAreas < ActiveRecord::Migration
  def change
    create_table :expertise_areas do |t|
      t.string :name

      t.timestamps
    end
  end
end
