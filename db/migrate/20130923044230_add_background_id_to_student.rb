class AddBackgroundIdToStudent < ActiveRecord::Migration
  def change
    add_column :students, :background_id, :integer
  end
end
