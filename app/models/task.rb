class Task < ApplicationRecord
  validates :title, :content, :deadline_on, :priority, :status, presence: true
  enum priority: [:low, :middle, :high]
  enum status: [:waiting, :working, :completed]
  
  scope :search, -> (search_params) do
    status_search(search_params[:status])
      .title_search(search_params[:title])
      .latest_deadline
      .highest_priority
  end

  scope :status_search, ->(status){where(status: status) if status.present?}
  scope :title_search, ->(part) {where("title like ?", "%#{part}%") if part.present?}
  scope :latest_deadline, -> {order(deadline_on: :asc)}
  scope :highest_priority, -> {order(priority: :desc)}
end
