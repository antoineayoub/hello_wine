class WinesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @wines = Wine.all

    #@wines = @wines.filter_by_location(params[:latitude], params[:longitude])
    @wines = @wines.filter_by_color(params[:color])
    @wines = @wines.filter_by_price(params[:price])
    @wines = @wines.filter_by_pairing(params[:pairing])

  end

  def show

  end
end
