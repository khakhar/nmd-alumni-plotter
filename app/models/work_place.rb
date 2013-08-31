class WorkPlace < ActiveRecord::Base
  belongs_to :student
  belongs_to :organisation
  belongs_to :place
  belongs_to :engagement_type

  include FlexiblePlace
  include FlexibleOrganisation

end
