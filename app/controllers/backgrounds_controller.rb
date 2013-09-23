class BackgroundsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_background, only: [:show, :edit, :update, :destroy]

  def index
    @backgrounds = Background.all
  end


  def show
  end


  def new
    @background = Background.new
  end


  def edit
  end


  def create
    @background = Background.new(background_params)

    respond_to do |format|
      if @background.save
        format.html { redirect_to @background, notice: 'Background was successfully created.' }
        format.json { render action: 'show', status: :created, location: @background }
      else
        format.html { render action: 'new' }
        format.json { render json: @background.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @background.update(background_params)
        format.html { redirect_to @background, notice: 'Background was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @background.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @background.destroy
    respond_to do |format|
      format.html { redirect_to backgrounds_url }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_background
      @background = Background.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def background_params
      params.require(:background).permit(:name)
    end
end
