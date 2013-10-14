class EngagementType < ActiveRecord::Base
  has_many :work_places, inverse_of: :engagement_type

  def self.internship
    EngagementType.find_by_name!("Internship")
  end

  def self.diploma_project
    EngagementType.find_by_name!("Diploma Project")
  end

  def self.job
    EngagementType.find_by_name!("Job")
  end
end
