class WinesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index

    @latitude = params[:latitude]
    @longitude = params[:longitude]

    @wines = Wine.all

    @wines = @wines.filter_by_location(@latitude, @longitude)

    @wines = @wines.filter_by_color(params[:color])
    @wines = @wines.filter_by_price(params[:price])
   # @wines = @wines.filter_by_pairing(params[:pairing])
  end

  def show
    @wine = Wine.find(params[:id])
    raise
    @store = @wine.nearest(@latitude,@longitude)
    raise
  end
end
