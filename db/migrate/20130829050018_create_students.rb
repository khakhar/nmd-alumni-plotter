class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.integer :place_id
      t.integer :expertise_area_id

      t.timestamps
    end
  end
end
