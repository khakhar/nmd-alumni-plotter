class Place < ActiveRecord::Base
  has_many :students
  has_many :work_places

  paginates_per 25
end
