class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: t('.success')
    else
      flash.now[:notice] = t('.fail')
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end