class UserAnswersController < ApplicationController

  def create
    @user_answer = UserAnswer.new(answer_params)
    @user_answer.user = current_user unless current_user.nil?
    # @user_answer.save

    # build search query
    search_query = ""
    answer_params.each do |key, value|
      search_query << " AND " unless search_query.length == 0
      if value.to_i == 0 || value.nil?
        search_query << "(#{key.to_s} = '#{value}')"
      else
        search_query << "(#{key.to_s} <= #{value.to_i})"
      end
    end

    redirect_to '/'
  end


  private


  def answer_params
    @answer_params = params.require(:user_answer).permit(:meal, :color, :price)
  end


end
