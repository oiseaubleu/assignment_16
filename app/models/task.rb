class Task < ApplicationRecord
  validates :title, :content, :deadline_on, :priority, :status, presence: true
  enum priority: [:low, :middle, :high]
  enum status: [:waiting, :working, :completed]
  
  scope :search, -> (search_params,sort_deadline_on,sort_priority,result) do
    status_search(search_params[:status])
      .title_search(search_params[:title])
      .normal_sort
      .latest_deadline(sort_deadline_on,result)
      .highest_priority(sort_priority)
  end

  scope :status_search, ->(status){where(status: status) if status.present?}
  scope :title_search, ->(part) {where("title like ?", "%#{part}%") if part.present?}
  scope :latest_deadline, ->(sort_deadline_on,result)  {result.order(deadline_on: :asc) if sort_deadline_on}
  scope :highest_priority, ->(sort_priority)  {order(priority: :desc) if sort_priority}
  #いるかな？
  scope :normal_sort, -> {order(created_at: :desc)}  
  
end
