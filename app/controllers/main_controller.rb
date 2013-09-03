class MainController < ApplicationController
  def index
    @expertise_areas = ExpertiseArea.order(:name).pluck(:name, :id)
    @students = Student.includes(:expertise_area).load
    @organisations = Organisation.all
    @places = Place.all
  end
end
