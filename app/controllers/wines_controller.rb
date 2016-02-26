class WinesController < ApplicationController

  def index

    @wines = Wine.filter_by_location(params[:latitude], params[:longitude])
    @wines = @wines.filter_by_color(params[:color])
    @wines = @wines.filter_by_price(params[:price])
    @wines = @wines.filter_by_pairing(params[:pairing])
  end
end
