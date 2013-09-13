class Student < ActiveRecord::Base
  has_many   :work_places
  belongs_to :place
  belongs_to :expertise_area

  include FlexiblePlace
  include Linkable

  validates_presence_of :name
  validates_presence_of :expertise_area_id
  validates_presence_of :place_id

  accepts_nested_attributes_for :work_places,
    reject_if: proc { |attributes| attributes['organisation_name'].blank? },
    allow_destroy: true

  paginates_per 50

  def internship
    self.work_places.where(engagement_type_id: EngagementType.internship).try(:first)
  end

  def current_work_place
    self.work_places.where(current: true).try(:first)
  end

end
