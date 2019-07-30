class Todo < ApplicationRecord
  belongs_to :list

  default_scope -> { order(completed_at: :desc, due_date: :asc) }
  scope :due_today, -> { where(completed_at: nil).where('due_date = CURRENT_DATE') }
  scope :overdue, -> { where(completed_at: nil).where('due_date < CURRENT_DATE') }

  def completed?
    completed_at != nil
  end

  def toggle_complete
    if completed?
      update! completed_at: nil
    else
      update! completed_at: DateTime.now
    end
  end

  def self.all_completed
    Todo.where.not(completed_at: nil)
  end

  def self.all_uncompleted
    Todo.where(completed_at: nil)
  end
end
