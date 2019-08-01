class Project < ApplicationRecord
  belongs_to :user
  belongs_to :label, optional: true
  has_many :lists, dependent: :destroy
  has_many :todos, through: :lists

  default_scope -> { includes(:todos).order("todos.due_date ASC") }
  scope :active, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  def archived?
    archived_at != nil
  end

  def toggle_archive
    if archived?
      update! archived_at: nil
    else
      update! archived_at: DateTime.now
    end
  end

  def today_todos
    todos.where(completed_at: nil).where('due_date = CURRENT_DATE')
  end

  def overdue_todos
    todos.where(completed_at: nil).where('due_date < CURRENT_DATE')
  end
end
