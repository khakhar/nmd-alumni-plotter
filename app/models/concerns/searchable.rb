module Searchable
  extend ActiveSupport::Concern


  included do
    scope :find_like, ->(name, options={wildcard: true}) {
      query = "%#{name}%"
      query = name if options[:wildcard] == false
      where("name ILIKE ?", query) 
    }
  end

end
