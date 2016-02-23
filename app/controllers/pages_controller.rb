class PagesController < ApplicationController
  def home
  end



  def questions
    @user_answer = UserAnswer.new
    @question1 = {
          question: "what food?",
          answers: [ "Meat", "Fish", "Vegie" ]
        }
    @question2 = {
          question: "what color?",
          answers: [ "Red", "Green", "White" ]
        }

    if @user_answer.save
      respond_to do |format|
        format.html { redirect_to 'pages/home' }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'pages/questions' }
        format.js  # <-- idem
      end
    end

  end

end
