class ExpertiseAreasController < ApplicationController
  before_action :set_expertise_area, only: [:show, :edit, :update, :destroy]

  # GET /expertise_areas
  # GET /expertise_areas.json
  def index
    @expertise_areas = ExpertiseArea.all
  end

  # GET /expertise_areas/1
  # GET /expertise_areas/1.json
  def show
  end

  # GET /expertise_areas/new
  def new
    @expertise_area = ExpertiseArea.new
  end

  # GET /expertise_areas/1/edit
  def edit
  end

  # POST /expertise_areas
  # POST /expertise_areas.json
  def create
    @expertise_area = ExpertiseArea.new(expertise_area_params)

    respond_to do |format|
      if @expertise_area.save
        format.html { redirect_to @expertise_area, notice: 'Expertise area was successfully created.' }
        format.json { render action: 'show', status: :created, location: @expertise_area }
      else
        format.html { render action: 'new' }
        format.json { render json: @expertise_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expertise_areas/1
  # PATCH/PUT /expertise_areas/1.json
  def update
    respond_to do |format|
      if @expertise_area.update(expertise_area_params)
        format.html { redirect_to @expertise_area, notice: 'Expertise area was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @expertise_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expertise_areas/1
  # DELETE /expertise_areas/1.json
  def destroy
    @expertise_area.destroy
    respond_to do |format|
      format.html { redirect_to expertise_areas_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expertise_area
      @expertise_area = ExpertiseArea.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expertise_area_params
      params.require(:expertise_area).permit(:name)
    end
end
