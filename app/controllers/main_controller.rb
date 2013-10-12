class MainController < ApplicationController
  def index
    @expertise_areas = ExpertiseArea.order(:name).pluck(:name, :id)
    @students = Student.where(approved: true).includes(:expertise_area)
    @organisations = Organisation.all
    @places = Place.all
    @backgrounds = Background.all
  end
end
