class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    authorize Question
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    authorize @question
    respond_with @question
  end

  def create
    authorize Question
    respond_with(@question = current_resource_owner.questions.create(question_params))
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end