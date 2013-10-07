class StudentInvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student_invite, only: [:show, :edit, :send, :update, :destroy]

  def index
    @student_invites = StudentInvite.order(:name)
  end

  def show
  end


  def send_invite
    @data = {}
    invites = []
    if params[:whom] == "not-sent"
      invites = StudentInvite.where(sent: false)
    else
      student_invite = StudentInvite.find_by(id: params[:id])
      invites.push(student_invite) if student_invite
    end

    invites.each do |invite|
      @data[invite.email] = {email: invite.email, token: invite.token}
    end

    StudentInvite.send_invites(@data)
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


  def upload
    @invites = []

    begin
      uploaded_file = params[:csv_file]
      csv_data = uploaded_file.read
      csv = CSV.parse csv_data

      csv.each do |row|
        name  = row[0]
        email = row[1]
        unless email.blank?
          invite = StudentInvite.find_or_initialize_by email: email
          unless invite.persisted?
            invite.name = name
            invite.save
            @invites.push({name: name, email: email})
          end
        end
      end
    rescue
      @csv_error  = true
      @no_file = true if params[:csv_file].blank?
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
