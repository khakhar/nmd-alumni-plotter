class MembersController < ApplicationController

  before_action :authenticate_user!
  before_action :find_user, only: [:edit, :update, :destroy]
  before_action :authorize!

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      format.html {
        if @user.save
          redirect_to members_path
        else
          render :new
        end
      }
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html {
          if current_user.id == @user.id
            redirect_to admin_path, notice: 'User details were successfully updated.'
          else
            redirect_to members_path, notice: 'User details were successfully updated.'
          end
        } 
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    if @user.id != current_user.id && @user.destroy
      flash[:notice] = "The user has been removed"
    else
      flash[:notice] = "There was a problem removing that user"
    end

    redirect_to members_path
  end


  private

  def user_params
    attributes = params.require(:user).permit(:email, :password, :password_confirmation, :role)
    if attributes[:password].empty?
      attributes.delete(:password) && attributes.delete(:password_confirmation)
    end
    attributes
  end

  def authorize!
    return if current_user.role == "admin"
    if !@user || @user.id != current_user.id || ["new", "destroy"].include?(params[:action])
      redirect_to admin_path, notice: "You are not allowed to do that :)"
    end
  end


  def find_user
    @user = User.find params[:id]
  end
end
