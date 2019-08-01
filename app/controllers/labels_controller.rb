
class LabelsController < ApplicationController
  before_action :load_label, only: [:edit, :update, :destroy]

  def index
    @labels = Current.user.labels
  end

  def new
    @label = Label.new
  end

  def create
    label = Current.user.labels.new label_params
    if label.save
      redirect_to labels_path, notice: 'Label created'
    else
      render :back, notice: 'Error! Label could not be created'
    end
  end

  def edit
  end

  def update
    if @label.update! label_params
      redirect_to labels_path, notice: 'Label updated'
    else
      render :back, notice: 'Error! Label could not be updated'
    end
  end

  def destroy
    if @label.destroy!
      redirect_to labels_path, notice: 'Label deleted'
    else
      render :back, notice: 'Error! Project could not be deleted'
    end
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def load_label
    @label = Label.find params[:id]
  end
end
