class WorkPlace < ActiveRecord::Base
  belongs_to :student, inverse_of: :work_places
  belongs_to :organisation, inverse_of: :work_places
  belongs_to :place, inverse_of: :work_places
  belongs_to :engagement_type, inverse_of: :work_places

  include FlexiblePlace
  include FlexibleOrganisation
end
