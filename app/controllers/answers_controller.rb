class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_question, except: [:vote_up, :vote_down, :vote_destroy]
  before_action :load_answer, only: [:update, :best, :destroy]

  include Voted

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    authorize @answer
    respond_with @answer if @answer.save
  end

  def update
    authorize @answer
    @answer.update(answer_params)
    respond_with @answer
  end

  def best
    authorize @answer
    flash.now[:notice] = t('.success') if @answer.is_best!
  end

  def destroy
    authorize @answer
    respond_with(@answer.destroy!)
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
