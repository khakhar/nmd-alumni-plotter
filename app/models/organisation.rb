class Organisation < ActiveRecord::Base
  has_many :work_places, inverse_of: :organisation

  include Searchable
  include Linkable

  paginates_per 25
end
