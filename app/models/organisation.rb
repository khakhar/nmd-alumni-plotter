class Organisation < ActiveRecord::Base
  has_many :work_places

  include Searchable

  paginates_per 25
end
