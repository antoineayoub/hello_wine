class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :questions]

  def home
  end

  def wines_filtering
    p wine_params
    if wine_params[:topic] == "color"
      p Wine.all.filter_by_color(wine_params[:value])
      nb_wines = Wine.all.filter_by_color(wine_params[:value]).length
      @wines = {nb_wines: nb_wines}
      # render questions to route to "questions.json.builder"
      render "questions"
      # render json: {nb_wines: nb_wines}  OR @wines
    elsif wine_params[:topic] == "price"
      nb_wines = @wines.filter_by_price(wine_params[:value])
      @wines = {nb_wines: nb_wines}
    else
      @wines = {nb_wines: 0}
      render "questions"
    end
  end

  def questions
    @user_answer = UserAnswer.new
    @questions = {
      color: {
            question: "What do you wanna drink ?",
            pic_url: "pic_color.png",
            answers: [ "Red Wine", "White Wine", "Rosé" ],
            values: [ "red", "white", "pink"]
          },
      pairing: {
            question: "What do you gonna eat ?",
            pic_url: "pic_meal.png",
            answers: [ "Hudge meat plate", "Bob the fish", "Piece of tofu" ],
            values: [ "viande", "poisson", "vegie"]
          },
      price: {
            question: "How much you wanna spend ?",
            pic_url: "pic_price.png",
            answers: [ "Less than 10€", "From 10 to 20€", "More than 20€" ],
            values: [ "less-10", "10-20", "more-20"]
          }
    }
  end

  private

  def wine_params
    params.require(:wine).permit(:topic, :value)
  end
end







