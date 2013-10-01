class EngagementType < ActiveRecord::Base
  has_many :work_places, inverse_of: :engagement_type

  def self.internship
    EngagementType.find_by_name!("Internship")
  end

  def self.job
    EngagementType.find_by_name!("Job")
  end
end
