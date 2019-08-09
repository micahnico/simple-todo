class Todo < ApplicationRecord
  belongs_to :list

  scope :display_order, -> { order(completed_at: :desc, due_date: :asc, description: :asc) }
  scope :due_today, -> { where(completed_at: nil).where('due_date = ?', Time.zone.today) }
  scope :overdue, -> { where(completed_at: nil).where('due_date < ?', Time.zone.today) }
  scope :in_progress, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  def completed?
    completed_at != nil
  end

  def toggle_complete
    if completed?
      update! completed_at: nil
    else
      update! completed_at: DateTime.now.in_time_zone
    end
  end

  def self.all_completed
    Todo.where.not(completed_at: nil)
  end

  def self.all_uncompleted
    Todo.where(completed_at: nil)
  end
end
