class CreateStudentBackgrounds < ActiveRecord::Migration
  def change
    create_table :student_backgrounds do |t|
      t.integer :student_id
      t.integer :background_id

      t.timestamps
    end
  end
end
