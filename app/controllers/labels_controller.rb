class LabelsController < ApplicationController
  before_action :set_label, only: %i[show edit update destroy]

  # GET /tasks
  def index
    @labels = Label.all
  end

  # # GET /tasks/1
  # def show
  # end

  # GET /tasks/new
  def new
    @label = Label.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @label = Label.new(label_params)

    if @label.save
      flash[:info] = 'ラベルを登録しました'
      redirect_to labels_path
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @label.update(label_params)
      flash[:info] = 'ラベルを更新しました'
      redirect_to labels_path
    else
      render :edit
    end
  end

  # # DELETE /tasks/1
  # def destroy
  #   @task.destroy
  #   redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_label
    @label = Label.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def label_params
    params.require(:label).permit(:name)
  end
end
