class CreateEngagementTypes < ActiveRecord::Migration
  def change
    create_table :engagement_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
