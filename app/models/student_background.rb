class StudentBackground < ActiveRecord::Base
  belongs_to :student
  belongs_to :background

  default_scope { order(:background_order) }

  include FlexibleBackground
end
