class CreateSiteOptions < ActiveRecord::Migration
  def change
    create_table :site_options do |t|
      t.string :name
      t.text :value

      t.timestamps
    end
  end
end
