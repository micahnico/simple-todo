
class ProjectsController < ApplicationController
  before_action :load_project, only: [:toggle_archive, :edit, :update, :destroy]

  def index
    @filter_projects = FilterProjects.execute(filter_params)
    @projects = @filter_projects.projects
    @overdue_todos = Todo.overdue
    @today_todos = Todo.due_today
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new project_params
    if @project.save
      redirect_to project_lists_path(@project), notice: 'Project created'
    else
      render :back, notice: 'Error! Project could not be created'
    end
  end

  def edit
  end

  def update
    if @project.update! project_params
      redirect_to projects_path, notice: 'Project updated'
    else
      render :back, notice: 'Error! Project could not be updated'
    end
  end

  def toggle_archive
    if @project.toggle_archive
      redirect_to projects_path, notice: 'Project archived'
    else
      render :back, notice: 'Error!'
    end
  end

  def destroy
    if @project.destroy!
      redirect_to projects_path, notice: 'Project deleted'
    else
      render :back, notice: 'Error! Project could not be deleted'
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def filter_params
    if params[:filter_projects]
      params.require(:filter_projects).permit(:query, :status)
    else
      {}
    end
  end

  def load_project
    @project = Project.find params[:id]
  end
end
