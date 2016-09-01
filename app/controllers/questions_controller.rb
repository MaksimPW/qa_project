class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update]
  before_action :load_question, only: [:show, :destroy, :update]

  include Voted

  def index
    authorize @questions = Question.all
    respond_with @questions
  end

  def show
  end

  def new
    authorize @question = Question.new
    respond_with @question
  end

  def create
    @question = current_user.questions.new(question_params)
    authorize @question
    if @question.save
      PrivatePub.publish_to '/questions', question: @question.to_json
      respond_with @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    return respond_with(@question.destroy!)
    render :show
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :type, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
    authorize @question
  end
end