class ExpertiseArea < ActiveRecord::Base
  has_many :students, inverse_of: :expertise_area
end
