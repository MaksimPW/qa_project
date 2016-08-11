class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_question, except: [:vote_up, :vote_down, :vote_destroy]
  before_action :load_answer, only: [:update, :best, :destroy]

  include Voted

  respond_to :js

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    respond_with @answer if @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with @answer
  end

  def best
    if current_user.author_of?(@question)
      flash.now[:notice] = t('.success') if @answer.is_best!
    end
  end

  def destroy
    respond_with(@answer.destroy!) if current_user.author_of?(@answer)
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
