class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_question
  before_action :load_answer, only: [:update, :best, :destroy]

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

  def best
    if current_user.author_of?(@question)
      flash.now[:notice] = t('.success') if @answer.is_best!
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      flash[:notice] = t('answers.delete.success') if @answer.destroy
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :type, :_destroy])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
