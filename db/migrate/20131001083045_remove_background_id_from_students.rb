class RemoveBackgroundIdFromStudents < ActiveRecord::Migration
  def change

    Student.all.each do |student|
      if student.background_id
        student.student_backgrounds.create background_id: student.background_id
      end
    end

    remove_column :students, :background_id, :integer
  end
end
