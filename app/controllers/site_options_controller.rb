class SiteOptionsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @site_options = SiteOption.all
  end


  def update
    @site_options = SiteOption.update(
      params[:site_options].keys,
      params[:site_options].values
    ).reject { |site_option| site_option.errors.empty? }

    if @site_options.empty?
      flash[:notice] = "Options updated"
      redirect_to edit_site_options_path
    else
      render action: "edit"
    end
  end

end
