class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @search_params = search_params
    # binding.irb
    # @tasks = Task.search(@search_params, params[:sort_deadline_on], params[:sort_priority]).page(params[:page])
    @tasks = current_user.tasks.search(@search_params, params[:sort_deadline_on],
                                       params[:sort_priority]).page(params[:page])
  end

  def new
    # @task = Task.new
    @task = current_user.tasks.build
  end

  def create
    # @task = Task.new(task_params) # インスタンスの作成
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:info] = t('.created')
      redirect_to tasks_path # 一覧画面へ
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = t('.updated')
      redirect_to @task # 詳細画面へ
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:info] = t('.destroyed')
    redirect_to tasks_path
  end

  private

  def set_task
    # @task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id])
  end

  # コンテンツしか受け入れないようにするストロングパラメータ {"content"=>"xxx"}みたいな戻り値
  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  def search_params
    params.fetch(:search, {}).permit(:title, :status)
  end
end
