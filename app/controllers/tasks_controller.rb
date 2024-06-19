class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params) #インスタンスの作成   
      if @task.save 
        flash[:info] = 'Task was successfully created.' 
        redirect_to @task
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
      flash[:info] = 'Task was successfully updated.'
      redirect_to tasks_path
    else
      render :edit
    end
  end


  def destroy
    @task.destroy 
      flash[:info] = 'Task was successfully destroyed.'
       redirect_to tasks_path
  end


  private
      def set_task
        @task = Task.find(params[:id])
      end
  
      # コンテンツしか受け入れないようにするストロングパラメータ {"content"=>"xxx"}みたいな戻り値
      def task_params
        params.require(:task).permit(:title,:content)
      end






end