class List < ApplicationRecord
  belongs_to :project
  has_many :todos, dependent: :destroy

  default_scope -> { includes(:todos).order("todos.due_date ASC") }
end
