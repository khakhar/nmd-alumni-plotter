class AddWebsiteToStudents < ActiveRecord::Migration
  def change
    add_column :students, :website, :text
  end
end
