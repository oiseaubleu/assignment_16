class LabelsController < ApplicationController
  before_action :set_label, only: %i[show edit update destroy]

  # GET /tasks
  def index
    @labels = current_user.labels #= Label.all
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    # @label = Label.new
    @label = current_user.labels.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    # @label = Label.new(label_params)
    @label = current_user.labels.build(label_params)
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

  # DELETE /tasks/1
  def destroy
    @label.destroy
    flash[:info] = 'ラベルを削除しました'
    redirect_to labels_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_label
    # @label = Label.find(params[:id])
    @label = current_user.labels.find_by(id: params[:id])
    if @label
    else
      flash[:danger] = 'アクセス権限がありません'
      redirect_to labels_path # (current_user.id)
    end
    # @label = current_user.tasks.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def label_params
    params.require(:label).permit(:name)
  end
end
