class UserAnswersController < ApplicationController

  def create
    @user_answer = UserAnswer.new(answer_params)
    @user_answer.user = current_user unless current_user.nil?

    redirect_to wines_path(params[:user_answer])
  end

  private

  def answer_params
    @answer_params = params.require(:user_answer).permit(:meal, :color, :price)
  end

end
