class StudentsController < ApplicationController
  before_action :auth_user_or_guest!, only: [:create, :new]
  before_action :authenticate_user!, except: [:create, :new]
  before_action :set_student, only: [:show, :edit, :update, :destroy]


  def index
    @students = Student.order(:name).page params[:page]
  end

  def show
  end

  def new
    @student = Student.new
  end

  def edit
  end


  def create
    student_attributes = student_params
    student_attributes.merge!(approved: false) if @invite

    @student = Student.new(student_attributes)

    if @student.save
      @invite.filled_for!(@student.id) if @invite
      if @invite
        render 'thank_you'
      else
        redirect_to @student, notice: 'Student was successfully created.'
      end
    else
      render action: 'new'
    end
  end


  def update
    @student.place_name = params[:student][:place_name]
    respond_to do |format|
      if @student.update_attributes(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end 
  end


  private
    def set_student
      @student = Student.find(params[:id])
    end


    def student_params
      permitted_params = [
        :id,
        :name,
        :place_name,
        :website,
        :place_id,
        :expertise_area_id,
        student_backgrounds_attributes: [:id, :background_name, :background_order, :_destroy],
        work_places_attributes: [
          :id,
          :project_title,
          :organisation_id, :organisation_name, :organisation_website,
          :place_id, :place_name,
          :engagement_type_id,
          :current,
          :_destroy
        ]
      ]

      permitted_params.push(:approved) if !@invite
      params.require(:student).permit(*permitted_params)
    end
end
