class Place < ActiveRecord::Base
  has_many :students
  has_many :work_places
end
