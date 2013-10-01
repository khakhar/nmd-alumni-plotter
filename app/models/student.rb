class Student < ActiveRecord::Base
  has_many   :work_places, inverse_of: :student
  belongs_to :place, inverse_of: :students
  belongs_to :expertise_area, inverse_of: :students
  has_many   :student_backgrounds, dependent: :destroy, inverse_of: :student
  has_one    :student_invite, dependent: :destroy, inverse_of: :student

  include FlexiblePlace
  include Linkable

  validates_presence_of :name
  validates_presence_of :expertise_area_id
  validates_presence_of :place_id

  accepts_nested_attributes_for(
    :work_places,
    reject_if: proc { |attributes| attributes['organisation_name'].blank? },
    allow_destroy: true
  )


  accepts_nested_attributes_for :student_backgrounds,
    reject_if: proc { |attributes| attributes['background_name'].blank? },
    allow_destroy: true

  paginates_per 50

  def internship
    self.work_places.where(engagement_type_id: EngagementType.internship).try(:first)
  end

  def current_work_place
    self.work_places.where(current: true).try(:first)
  end

  def chosen_student_background
    self.student_backgrounds.try(:first)
  end

  def background_id
    self.chosen_student_background.try(:background_id)
  end

end
