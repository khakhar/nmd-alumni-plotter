class StudentInvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student_invite, only: [:show, :edit, :update, :destroy]

  def index
    @student_invites = StudentInvite.order(:name)
  end

  def show
  end

  def new
    @student_invite = StudentInvite.new
  end

  def edit
  end

  def create
    @student_invite = StudentInvite.new(student_invite_params)

    respond_to do |format|
      if @student_invite.save
        format.html { redirect_to student_invites_path, notice: 'student_invite was successfully created.' }
        format.json { render action: 'show', status: :created, location: student_invites_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @student_invite.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @student_invite.update(student_invite_params)
        format.html { redirect_to student_invites_path, notice: 'student_invite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @student_invite.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @student_invite.destroy
    respond_to do |format|
      format.html { redirect_to student_invites_url }
      format.json { head :no_content }
    end
  end


  def delete_multiple
    if params[:delete_option] == "expired"
      StudentInvite.where.not(student_id: nil).destroy_all
    end
    if params[:delete_option] == "all"
      StudentInvite.destroy_all
    end
    redirect_to student_invites_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_invite
      @student_invite = StudentInvite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_invite_params
      params.require(:student_invite).permit(:name, :email)
    end
end
