class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_question

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash.now[:notice] = t('.success')
    else
      flash.now[:notice] = t('.fail')
    end
  end

  def update
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        flash.now[:notice] = t('.success')
      else
        flash.now[:notice] = t('.fail')
      end
    else
      flash.now[:notice] = t('.fail')
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      flash[:notice] = t('answers.delete.success') if @answer.destroy
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
