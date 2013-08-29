class Student < ActiveRecord::Base
  belongs_to :place
  belongs_to :expertise_area
end
