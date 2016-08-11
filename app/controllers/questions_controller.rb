class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update]
  before_action :load_question, only: [:show, :destroy, :update]

  include Voted

  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      PrivatePub.publish_to '/questions', question: @question.to_json
      respond_with @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    respond_with @question
  end

  def destroy
    return respond_with(@question.destroy!) if current_user.author_of?(@question)
    render :show
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :type, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end