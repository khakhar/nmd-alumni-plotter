desc "Populate database with samples"
task populate_samples: :environment do
  Maintenance.populate_with_samples!
end


desc "Clear all user entered data"
task clear_data: :environment do
  Maintenance.clear_data!
end
