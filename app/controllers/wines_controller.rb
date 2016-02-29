class WinesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @wines = Wine.all.first(50)
    # @wines = @wines.filter_by_location(params[:latitude], params[:longitude])
    # @wines = @wines.filter_by_color(params[:color])
    # @wines = @wines.filter_by_price(params[:price])
    # @wines = @wines.filter_by_pairing(params[:pairing])
    wine_sorted = wine_sorting(@wines)
  end

  def show
    @wine = Wine.find(params[:id])
  end

  private

  def wine_sorting(wines)
    wines_matrix = []
    wines.each do |wine|
      rating_value = wine.external_ratings[2].avg_rating
      rating_score = [0.3*(rating_value-2)*100,0].max

      distance_value = (10..600).to_a.sample
      distance_score = 100-distance_value/6

      score = (rating_score + distance_score)/2
      wines_matrix << { wine: wine, score: score, distance: distance_value, rating_score: rating_score, distance_score: distance_score}
    end

    @wines = wines_matrix.sort { | a, b | b[:score] <=> a[:score] }

end
