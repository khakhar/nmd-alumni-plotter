class CreateStudentInvites < ActiveRecord::Migration
  def change
    create_table :student_invites do |t|
      t.string  :name
      t.string  :email
      t.text    :token
      t.integer :student_id

      t.timestamps
    end
  end
end
