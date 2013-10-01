module FlexibleOrganisation
  extend ActiveSupport::Concern

  included do
    before_save :ensure_organisation_id


    def organisation_name
      self.organisation.name if self.organisation
    end

    def organisation_website
      self.organisation.website if self.organisation
    end


    def organisation_name=(value)
      @organisation_name = value
      attribute_will_change!(:organisation_name)
    end


    def organisation_website=(value)
      @organisation_website = value
      attribute_will_change!(:organisation_website)
    end


    def ensure_organisation_id
      return if self.organisation && self.organisation.name == @organisation_name
      return if @organisation_name.blank?
      search = Organisation.find_like(@organisation_name, wildcard: false)

      if search.length > 0
        organisation = search.first
      else
        organisation = Organisation.create(
          name: @organisation_name,
          website: @organisation_website
        )
      end

      self.organisation_id = organisation.id
    end
  end

end
