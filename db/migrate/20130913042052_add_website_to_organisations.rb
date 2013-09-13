class AddWebsiteToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :website, :text
  end
end
