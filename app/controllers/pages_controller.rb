class PagesController < ApplicationController
  def home
  end



  def questions
    @user_answer = UserAnswer.new

    @questions = {
      meal: {
            question: "Que vas-tu manger?",
            answers: [ "de la viande", "du poisson", "végétarien" ],
            values: [ "viande", "poisson", "vegie"]
          },
      color: {
            question: "Quel vin préfères-tu?",
            answers: [ "Vin Rouge", "Vin Rosé", "Vin Blanc" ],
            values: [ "rouge", "rose", "blans"]
          },
      price: {
            question: "Quel montant veux-tu dépenser?",
            answers: [ "moins de 10€", "entre 10 et 20€", "plus de 20€" ],
            values: [ "less-10", "10-20", "more-20"]
          }
    }
  end


end







