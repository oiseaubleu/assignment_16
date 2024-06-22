class Task < ApplicationRecord
  validates :title, :content, :deadline_on, :priority, :status, presence: true
  enum priority: [:low, :middle, :high]
  enum status: [:waiting, :working, :completed]
  
  scope :search, -> (search_params,sort_deadline_on,sort_priority)do
    status_search(search_params[:status])
      .title_search(search_params[:title])
      .latest_deadline(sort_deadline_on)
      .highest_priority(sort_priority)
      .normal_sort
  end

  # scope :search_sort, -> (search_params,sort_deadline_on,sort_priority) do
  #   status_search(search_params[:status])
  #     .title_search(search_params[:title])
  #     .latest_deadline(sort_deadline_on)
  #     .highest_priority(sort_priority)
  # end

  # scope :all_sort, -> (sort_deadline_on,sort_priority) do
  #     latest_deadline(sort_deadline_on)
  #     .highest_priority(sort_priority)
  #     .normal_sort
  # end

  scope :status_search, ->(status){where(status: status) if status.present?}
  scope :title_search, ->(part) {where("title like ?", "%#{part}%") if part.present?}
  scope :latest_deadline, ->(sort_deadline_on)  {order(deadline_on: :asc) if sort_deadline_on}
  scope :highest_priority, ->(sort_priority)  {order(priority: :desc) if sort_priority}
  #いるかな？
  scope :normal_sort, -> {order(created_at: :desc)}  
  
end
