class UsersController < ApplicationController
  before_action :load_user, except: [:index, :new, :create]
  before_action :authorize_user, except: [:index, :new, :create, :show]
  before_action :redirect_to_root, only: [:new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "Пользователь успешно зарегестрирован!"
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Данные обновлены"
    else
      render 'edit'
    end
  end

  def edit
  end

  def destroy
    @user.destroy
    redirect_to root_url, notice: "Пользователь удален"
  end

  def show
    @head = @user.head
    @questions = @user.questions.order(created_at: :desc)

    @new_question = @user.questions.build

    @answers_count = @questions.where.not(answer: nil).count
    @unanswered_count = @questions.size - @answers_count
  end

  private
  def redirect_to_root
    redirect_to root_url, alert: "Вы уже залогинены!" if current_user.present?
  end

  def authorize_user
    reject_user unless @user == current_user
  end

  def load_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :username, :avatar_url, :head)
  end
end
