module FlexibleBackground
  extend ActiveSupport::Concern

  included do
    before_save :ensure_background_id


    def background_name
      self.background.name if self.background
    end


    def background_name=(value)
      @background_name = value
      attribute_will_change!(:background_name)
    end


    def ensure_background_id
      return if self.background && self.background.name == @background_name
      return if @background_name.blank?
      search = Background.find_like(@background_name, wildcard: false)

      if search.length > 0
        background = search.first
      else
        background = Background.create name: @background_name
      end

      self.background_id = background.id
    end
  end

end
