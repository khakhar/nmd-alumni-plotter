class Background < ActiveRecord::Base
  has_many :student_backgrounds, inverse_of: :background

  include Searchable
end
