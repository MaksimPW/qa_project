class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update]
  before_action :load_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: t('.success')
    else
      flash.now[:notice] = t('.fail')
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash.now[:notice] = t('.success')
      else
        flash.now[:notice] = t('.fail')
      end
    else
      flash.now[:notice] = t('.fail')
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: t('questions.delete.success')
    else
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :type, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end