class Label < ApplicationRecord
  belongs_to :user
  has_many :projects
  before_destroy :remove_label_from_projects

  default_scope -> { order(name: :asc) }

  private def remove_label_from_projects
    projects.update_all label_id: nil
  end
end
