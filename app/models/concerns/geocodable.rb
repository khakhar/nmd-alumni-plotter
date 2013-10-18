module Geocodable
  extend ActiveSupport::Concern

  included do
    attr_accessor :disable_geocoding
    before_save   :ensure_geocoding

    def ensure_geocoding
      return true if @disable_geocoding
      self.geocode() if self.name_changed? || self.country_code_changed?
      true #NOTE even if geocoding fails, just save the document
    end

    def geocode
      request_params = {sensor: false}
      request_params[:components] = "country:#{self.country_code}" if self.country_code

      data = Geocoder.search(self.name, params: request_params)
      return false if data.count == 0

      self.latitude     = data[0].latitude
      self.longitude    = data[0].longitude
      self.country_code = data[0].country_code if !self.country_code
    rescue => e
      return false
    end

  end
end
