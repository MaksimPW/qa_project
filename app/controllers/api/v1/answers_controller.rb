class Api::V1::AnswersController < Api::V1::BaseController
  def index
    authorize Answer
    @question = Question.find(params[:question_id])
    @answers = @question.answers.sort_by(&:id)
    respond_with @answers
  end

  def show
    @answer = Answer.find(params[:id])
    authorize @answer
    respond_with @answer
  end

  def create
    authorize Answer
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_resource_owner)), location: false)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end