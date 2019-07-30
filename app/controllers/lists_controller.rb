class ListsController < ApplicationController
  before_action :load_project
  before_action :load_list, only: [:edit, :update, :destroy]

  def index
    @lists = @project.lists
  end

  def new
    @list = List.new
  end

  def create
    @list = @project.lists.new list_params
    if @list.save
      redirect_to project_lists_path(@project), notice: 'List created'
    else
      render :back, notice: 'Error! List could not be created'
    end
  end

  def edit
  end

  def update
    if @list.update! list_params
      redirect_to project_lists_path(@project), notice: 'List updated'
    else
      render :back, notice: 'Error! List could not be updated'
    end
  end

  def destroy
    if @list.destroy!
      redirect_to project_lists_path(@project), notice: 'List deleted'
    else
      render :back, notice: 'Error! List could not be deleted'
    end
  end

  private

  def list_params
    params.require(:list).permit(:name, :project_id)
  end

  def load_project
    @project = Project.find params[:project_id]
  end

  def load_list
    @list = List.find params[:id]
  end
end
