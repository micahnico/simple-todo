class TodoSearch < CommandModel::Model
  parameter :query
  parameter :list_id, presence: true

  attr_reader :todos

  def execute
    list = List.find list_id
    if query
      @todos = list.todos.where("description ILIKE ?", "%#{query}%")
    else
      @todos = list.todos
    end
  end
end