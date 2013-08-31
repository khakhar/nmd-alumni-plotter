class AddStudentIdToWorkPlaces < ActiveRecord::Migration
  def change
    add_column :work_places, :student_id, :integer
  end
end
