class Task < ActiveRecord::Base

  belongs_to :project
  belongs_to :user
  belongs_to :assignee, class_name: "User", foreign_key: "assigned_user_id" 

  enum priority: ['whenever', 'low', 'medium', 'high', 'immediate']
  
  validates :name, presence: true
  validates :description, presence: true
  validates :user_id, presence: true
  validates :assigned_user_id, presence: true
  validate :past_due

  def past_due
    if due_date <= Time.now
      errors.add(:due_date, "nothing in the past please")
    end
  end

  def toggle
    self.complete = !self.complete
    self.save
  end
end
