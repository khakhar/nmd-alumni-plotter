class WorkPlace < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :places
  belongs_to :engagement_type
end
