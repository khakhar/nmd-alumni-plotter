class AddProjectTitleToWorkPlaces < ActiveRecord::Migration
  def change
    add_column :work_places, :project_title, :text
  end
end
