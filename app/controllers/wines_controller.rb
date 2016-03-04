class WinesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :all, :closed, :nowine]

  def all
    @wines = Wine.all
  end

  def index
    puts "CONTROLLER ENTRANCE"
    puts @latitude = params[:latitude]
    puts @longitude = params[:longitude]
    @skip_navbard = true
    @get_loader = true

    @wines = Wine.find_wines(@latitude,@longitude,params[:color],params[:price],params[:pairing])
    puts "END FIND WINES"
    puts "1er vin sortir find wines"

    if @wines == 1 || @wines == 3 || @wines == 4 || @wines == 5
      redirect_to nowine_wines_path
    elsif @wines == 2
      redirect_to closed_wines_path
    else
      puts @wines.first
      @wines = wine_sorting(@wines, @latitude, @longitude) unless @latitude == "undefined" || @longitude == "undefined"
      puts "END WINE SORTING"
      puts @wines.first
      @wines = @wines.first(10)
    end

  end

  def show
    @wine = Wine.find(params[:id])
    @store = Store.find(params[:store_id])
    @store_closed =  @store.store_schedules.where(day: Date.today.cwday).first[:end_pm]
    @store_closed = Time.now.change({ hour: @store_closed.hour, min: @store_closed.min })

    if @store.nil?
      redirect_to closed_wines_path
    else

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
    weight_rating = 0.9
    weight_distance = 0.1
    puts "WINE SORTING"
    wines.each do |wine|

      unless wine.external_ratings.first.nil?
        info_store = wine.nearest(latitude,longitude)
        puts "info store"
        puts info_store
        rating_score = wine.external_ratings.last.avg_rating * 20 * weight_rating
        distance_score = distance_note( info_store[:distance] ) * weight_distance

        puts "rating_score"
        puts rating_score

        puts "distance_score"
        puts distance_score

        if rating_score.nil?
          score = 0
        else
          score = (rating_score + distance_score).round
        end
        wines_matrix << { wine: wine, score: score, info_store: info_store } unless wine.photo == "null"
      end
    end
    puts "wine wines_matrix"
    puts wines_matrix.count
    @wines = wines_matrix.sort { | a, b | b[:score] <=> a[:score] }

  end

  def distance_note(distance)
    if distance <= 50
      return 100
    elsif distance > 50 && distance <= 500
      return -( 1.to_f / 9 ) * (distance + 50) + 100
    elsif distance > 500 && distance <= 600
      return - ( 1.to_f / 2 ) * distance + 300
    else
      return 0
    end

  end

end
