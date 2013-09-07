module FlexiblePlace
  extend ActiveSupport::Concern

  included do
    attr_accessor :place_name
    before_validation   :ensure_place_id


    def place_name
      self.place.name if self.place
    end


    def ensure_place_id
      return if self.place && self.place.name == @place_name
      return if @place_name.blank?
      search = Place.find_like(@place_name, wildcard: false)

      if search.length > 0
        place = search.first
      else
        place = Place.create name: @place_name
      end

      self.place_id = place.id
    end
  end

end
