class TodosController < ApplicationController
  before_action :load_project
  before_action :load_list
  before_action :load_todo, only: [:edit, :update, :show, :destroy, :toggle_complete]

  def index
    @search = TodoSearch.execute search_params
    @todos = @search.todos
    @tab = params[:tab]
  end

  def create
    @todo = @list.todos.new todo_params
    if @todo.save
      redirect_to project_list_todos_path(@project, @list), notice: 'Todo created'
    else
      render :back, notice: 'Error! Todo could not be created'
    end
  end

  def update
    tab = @todo.completed? ? 'completed' : nil
    if @todo.update! todo_params
      redirect_to project_list_todos_path(@project, @list, tab: tab), notice: 'Todo updated'
    else
      render :back, notice: 'Error! Todo could not be updated'
    end
  end

  def destroy
    tab = @todo.completed? ? 'completed' : nil
    if @todo.destroy!
      redirect_to project_list_todos_path(@project, @list, tab: tab), notice: 'Todo deleted'
    else
      render :back, notice: 'Error! Todo could not be deleted'
    end
  end

  def toggle_complete
    tab = @todo.completed? ? 'completed' : nil
    if @todo.toggle_complete
      redirect_to project_list_todos_path(@project, @list, tab: tab)
    else
      render :back, notice: 'Error!'
    end
  end

  private

  def search_params
    if params[:todo_search]
      params.require(:todo_search).permit(:query).merge(list_id: @list.id)
    else
      {list_id: @list.id}
    end
  end

  def load_todo
    @todo = Todo.find params[:id]
  end

  def load_project
    @project = Project.find params[:project_id]
  end

  def load_list
    @list = List.find params[:list_id]
  end

  def todo_params
    params.require(:todo).permit(:description, :completed_at, :due_date, :list_id)
  end
end
