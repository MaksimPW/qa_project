class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  respond_to :js

  def create
    authorize Subscription
    @question.subscribe!(current_user)
    respond_with @subscription
  end

  def destroy
    @subscription = Subscription.find_by(question_id: @question, user_id: current_user)
    authorize @subscription
    respond_with @subscription.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end