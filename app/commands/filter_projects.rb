class FilterProjects < CommandModel::Model
  parameter :query, :status, :label_id
  parameter :user, presence: true

  attr_reader :projects

  def execute
    @projects = user.projects.active

    if status.present?
      @projects = if status == 'archived'
        user.projects.archived
      elsif status == 'all'
        user.projects
      end
    end

    if label_id.present?
      @projects = if label_id == 'none'
        @projects.where label_id: nil
      else
        @projects.where label_id: label_id
      end
    end

    if query.present?
      @projects = @projects.includes(:lists, :todos).where("projects.name ILIKE :query OR projects.description ILIKE :query OR lists.name ILIKE :query OR todos.description ILIKE :query", query: "%#{query}%")
    end

  end
end