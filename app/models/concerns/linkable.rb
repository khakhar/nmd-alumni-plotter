module Linkable
  extend ActiveSupport::Concern

  included do

    def full_url
      actual_url = self.website
      return nil if actual_url.blank?
      return actual_url if actual_url =~ /^http(s)?:\/\/.+$/
      "http://#{actual_url}"
    end

  end
end
