module FlexibleOrganisation
  extend ActiveSupport::Concern

  included do
    attr_accessor :organisation_name
    before_save :ensure_organisation_id


    def organisation_name
      self.organisation.name if self.organisation
    end


    def ensure_organisation_id
      return if self.organisation && self.organisation.name == @organisation_name
      return if @organisation_name.blank?
      search = Organisation.find_like(@organisation_name, wildcard: false)

      if search.length > 0
        organisation = search.first
      else
        organisation = Organisation.create name: @organisation_name
      end

      self.organisation_id = organisation.id
    end
  end

end
