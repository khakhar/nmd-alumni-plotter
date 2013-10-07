class AddSentToStudentInvites < ActiveRecord::Migration
  def change
    add_column :student_invites, :sent, :boolean, default: false
  end
end
