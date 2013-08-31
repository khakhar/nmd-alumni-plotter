class MainController < ApplicationController
  def index
    @expertise_areas = ExpertiseArea.order(:name).pluck(:name, :id)
    @students = Student.includes(:expertise_area, :place).load
  end
end
