class WinesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    @skip_navbard = true

    @wines = Wine.all

    @wines = @wines.filter_by_location(@latitude, @longitude)

    @wines = @wines.filter_by_color(params[:color])

    @wines = @wines.filter_by_price(params[:price])

   #@wines = @wines.filter_by_pairing(params[:pairing])

    @wines = wine_sorting(@wines, @latitude, @longitude)

  end

  def show
    @wine = Wine.find(params[:id])
    @store = Store.find(params[:store_id])

    if @store.nil?
      redirect_to closed_wines_path
    else
      # @store = store[:store]
      # @distance = store[:distance]

      # Let's DYNAMICALLY build the markers for the view.
      @markers = Gmaps4rails.build_markers(@stores) do |store, marker|
        marker.lat store.latitude
        marker.lng store.longitude
      end

    end
  end

  private

  def wine_sorting(wines,latitude,longitude)
    wines_matrix = []
    wines.each do |wine|
      info_store = wine.nearest(latitude,longitude)


      rating_value = wine.external_ratings[2].avg_rating unless wine.external_ratings[2].nil?
      rating_score = [0.3*(rating_value - 2)*100,0].max unless rating_value.nil?

      distance_value = ( info_store[:distance] * 1000 ).round
      distance_score = 100 - distance_value / 6

      if rating_score.nil?
        score = 0
      else
        score = (rating_score + distance_score)/2
      end
      wines_matrix << { wine: wine, score: score, info_store: info_store }
    end

    @wines = wines_matrix.sort { | a, b | b[:score] <=> a[:score] }
  end

end
