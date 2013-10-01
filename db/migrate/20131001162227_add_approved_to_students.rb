class AddApprovedToStudents < ActiveRecord::Migration
  def change
    add_column :students, :approved, :boolean, default: true
  end
end
