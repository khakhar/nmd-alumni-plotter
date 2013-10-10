# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["Internship", "Job"].each do |name|
  EngagementType.find_or_create_by name: name
end

user = User.find_or_create_by email: "admin@example.com"
unless user.persisted?
  user.password = "password"
  user.role = "admin"
  user.save
end

site_option = SiteOption.find_or_create_by name: "invite_email_text"
