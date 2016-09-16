class Api::V1::QuestionsController < Api::V1::ApplicationController
  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end
end