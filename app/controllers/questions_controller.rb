class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, except: [:create]

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if verify_recaptcha(model: @question)
      if @question.save
        redirect_to user_path(@question.user), notice: "Вопрос задан"
      else
        render :edit
      end
    else
      redirect_to user_path(@question.user), notice: "Подтвердите, что вы не робот )"
    end
  end

  def update
    if @question.update(question_params)
      redirect_to user_path(@question.user), notice: "Вопрос сохранен"
    else
      render :edit
    end
  end

  def destroy
    user = @question.user
    @question.destroy
    redirect_to user_path(@question.user), notice: "Вопрос удален"
  end

  private
    def find_author(author_id)
      User.find_by(id: author_id)
    end

    def authorize_user
      reject_user unless @question.user == current_user
    end

    def question_params
      if current_user.present? && params[:question][:user_id].to_i == current_user.id
        params.require(:question).permit(:user_id, :text, :answer, :author_id)
      else
        params.require(:question).permit(:user_id, :text, :author_id)
      end
    end
end
