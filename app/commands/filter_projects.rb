class FilterProjects < CommandModel::Model
  parameter :query, :status

  attr_reader :projects

  def execute
    @projects = Project.active

    if status.present?
      @projects = if status == 'archived'
        Project.archived
      elsif status == 'all'
        Project.all
      end
    end

    if query.present?
      @projects = @projects.includes(:lists, :todos).where("projects.name ILIKE :query OR projects.description ILIKE :query OR lists.name ILIKE :query OR todos.description ILIKE :query", query: "%#{query}%")
    end

  end
end