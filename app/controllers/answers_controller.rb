class AnswersController < ApplicationController
  before_action :load_question

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_path(@question), notice: t('.success')
    else
      flash.now[:notice] = t('.fail')
      render 'questions/show'
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
