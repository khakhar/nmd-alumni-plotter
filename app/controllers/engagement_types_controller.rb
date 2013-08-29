class EngagementTypesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_engagement_type, only: [:show, :edit, :update, :destroy]

  # GET /engagement_types
  # GET /engagement_types.json
  def index
    @engagement_types = EngagementType.all
  end

  # GET /engagement_types/1
  # GET /engagement_types/1.json
  def show
  end

  # GET /engagement_types/new
  def new
    @engagement_type = EngagementType.new
  end

  # GET /engagement_types/1/edit
  def edit
  end

  # POST /engagement_types
  # POST /engagement_types.json
  def create
    @engagement_type = EngagementType.new(engagement_type_params)

    respond_to do |format|
      if @engagement_type.save
        format.html { redirect_to @engagement_type, notice: 'Engagement type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @engagement_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @engagement_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /engagement_types/1
  # PATCH/PUT /engagement_types/1.json
  def update
    respond_to do |format|
      if @engagement_type.update(engagement_type_params)
        format.html { redirect_to @engagement_type, notice: 'Engagement type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @engagement_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /engagement_types/1
  # DELETE /engagement_types/1.json
  def destroy
    @engagement_type.destroy
    respond_to do |format|
      format.html { redirect_to engagement_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_engagement_type
      @engagement_type = EngagementType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def engagement_type_params
      params.require(:engagement_type).permit(:name)
    end
end
