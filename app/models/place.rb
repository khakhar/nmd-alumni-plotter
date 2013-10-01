class Place < ActiveRecord::Base
  has_many :students,    inverse_of: :place
  has_many :work_places, inverse_of: :place

  include Geocodable
  include Searchable

  def country
    Carmen::Country.coded(self.country_code).name unless self.country_code.blank?
  end


  def name_with_country
    "#{self.name}#{", " + self.country if self.country_code}"
  end
end
