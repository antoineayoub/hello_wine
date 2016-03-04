class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :questions, :wines_filtering]

  def home
    @get_loader = true
    @wine_count = Wine.all.count
  end

  def wines_filtering
    if wine_params[:topic] == "color"
      nb_wines = Wine.all.filter_by_color(wine_params[:value]).length
      @wines = {nb_wines: nb_wines}
      # render questions to route to "questions.json.builder"
      render "questions"
      # render json: {nb_wines: nb_wines}  OR @wines
    elsif wine_params[:topic] == "price"
      nb_wines = @wines.filter_by_price(wine_params[:value])
      @wines = {nb_wines: nb_wines}
    else
      nb_wines = Wine.all.length
      @wines = {nb_wines: nb_wines}
      render "questions"
    end
  end

  def questions
    @user_answer = UserAnswer.new

    # @questions = {
    #   color: {
    #         question: "What do you wanna drink ?",
    #         pic_url: "pic_color.png",
    #         answers: [ "Red Wine", "White Wine", "Rosé Wine" ],
    #         values: [ "red", "white", "pink"]
    #       },
    #   pairing: {
    #         question: "What do you gonna eat ?",
    #         pic_url: "pic_meal.png",
    #         answers: [ "Hudge meat plate", "Bob the fish", "Piece of tofu" ],
    #         values: [ "viande", "poisson", "vegie"]
    #       },
    #   price: {
    #         question: "How much you wanna spend ?",
    #         pic_url: "pic_price.png",
    #         answers: [ "Less than 10€", "From 10 to 20€", "More than 20€" ],
    #         values: [ "less-10", "10-20", "more-20"]
    #       }
    # }
  end
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  private

  def wine_params
    params.require(:wine).permit(:topic, :value)
  end
end







