class Organisation < ActiveRecord::Base
  has_many :work_places

  paginates_per 25
end
