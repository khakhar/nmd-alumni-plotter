class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    @students_count = Student.count
    @places_count   = Place.count
    @users_count    = User.count
    @organisations_count      = Organisation.count
    @engagement_types_count   = EngagementType.count
    @areas_of_expertise_count = ExpertiseArea.count
  end


  def tasks
  end


  def perform_task
    if params[:perform] == "clear_data"
      Maintenance.clear_data!
      redirect_to admin_path, notice: "Cleared all necessary data start over!"
    else
      render text: "what?"
    end
  end

end
