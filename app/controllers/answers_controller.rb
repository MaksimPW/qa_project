class AnswersController < ApplicationController
  before_action :load_question

  def create
    @answer = Answer.new(answer_params, question_id: @question)
    if @answer.save
      redirect_to question_path(@question)
    else
      redirect_to question_path(@question)
      # TODO: Add render error message for invalid answer
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
