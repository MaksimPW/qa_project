class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    authorize Subscription
    @question.subscribe!(current_user)
    respond_with @subscription
  end

  def destroy
    @question = Question.find(params[:question_id])
    @subscription = Subscription.find_by(question_id: @question, user_id: current_user)
    authorize @subscription
    respond_with @subscription.destroy
  end
end