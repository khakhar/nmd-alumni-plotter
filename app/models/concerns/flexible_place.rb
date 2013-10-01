module FlexiblePlace
  extend ActiveSupport::Concern

  included do
    before_validation   :ensure_place_id


    def place_name
      self.place.name if self.place
    end


    def place_name=(name)
      @place_name = name
      attribute_will_change!(:place_name)
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
