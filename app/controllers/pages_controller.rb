class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :questions]

  def home
  end


  def questions
    @user_answer = UserAnswer.new

    @questions = {
      color: {
            question: "What do you wanna drink ?",
            answers: [ "Red Wine", "White Wine", "Rosé" ],
            values: [ "red", "white", "pink"]
          },
      pairing: {
            question: "What do you gonna eat ?",
            answers: [ "Hudge meat plate", "Bob the fish", "Piece of tofu" ],
            values: [ "viande", "poisson", "vegie"]
          },
      price: {
            question: "How much you wanna spend ?",
            answers: [ "Less than 10€", "From 10 to 20€", "More than 20€" ],
            values: [ "less-10", "10-20", "more-20"]
          }
    }
  end


end







