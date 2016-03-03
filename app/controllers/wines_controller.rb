class WinesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :all, :closed]

  def all
    @wines = Wine.all
  end

  def index
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    @skip_navbard = true
    @wines = Wine.find_wines(@latitude,@longitude,params[:color],params[:price],params[:paring])

    if @wines.nil? || @wines.length == 0
      redirect_to closed_wines_path
    else
      @wines = wine_sorting(@wines, @latitude, @longitude)
    end

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
    weight_rating = 0.7
    weight_distance = 0.3

    wines.each do |wine|

      unless wine.external_ratings.first.nil?
        info_store = wine.nearest(latitude,longitude)

        rating_score = wine.external_ratings.first.avg_rating * 10 * weight_rating
        distance_score = distance_note( info_store[:distance] ) * weight_distance
        if rating_score.nil?
          score = 0
        else
          score = (rating_score + distance_score).round
        end
        wines_matrix << { wine: wine, score: score, info_store: info_store }
      end
    end

    @wines = wines_matrix.sort { | a, b | b[:score] <=> a[:score] }
  end

  def distance_note(distance)
    if distance <= 50
      return 100
    elsif distance > 50 && distance <= 500
      return 1/9 * (distance * 50) + 100
    elsif distance > 500 && distance <= 600
      return (distance + 150) / 2
    else
      return 0
    end
  end

end
