class PagesController < ApplicationController
  def home
  end



  def questions
    @user_answer = UserAnswer.new

    @questions = {
      meal: {
            question: "what food?",
            answers: [ "Meat", "Fish", "Vegie" ],
            values: [ "meat", "fish", "vegie"]
          },
      color: {
            question: "what color?",
            answers: [ "Red", "rosé", "White" ],
            values: [ "red", "rose", "white"]
          },
      price: {
            question: "what price?",
            answers: [ "less than 10€", "10-20€", "more than 20€" ],
            values: [ "10", "20", "1000"]
          }
    }
  end


end







