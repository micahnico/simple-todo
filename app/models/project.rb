class Project < ApplicationRecord
  has_many :lists, dependent: :destroy
  has_many :todos, through: :lists

  default_scope -> { includes(:todos).order("todos.due_date ASC") }

  def today_todos
    todos.where(completed_at: nil).where('due_date = CURRENT_DATE')
  end

  def overdue_todos
    todos.where(completed_at: nil).where('due_date < CURRENT_DATE')
  end
end
