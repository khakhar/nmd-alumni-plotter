class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    @students_count = Student.count
    @places_count  = Place.count
    @organisations_count      = Organisation.count
    @engagement_types_count   = EngagementType.count
    @areas_of_expertise_count = ExpertiseArea.count
  end
end
