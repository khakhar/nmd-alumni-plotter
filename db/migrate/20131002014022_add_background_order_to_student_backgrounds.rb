class AddBackgroundOrderToStudentBackgrounds < ActiveRecord::Migration
  def change
    add_column :student_backgrounds, :background_order, :integer, default: 0
  end
end
