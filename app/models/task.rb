class Task < ApplicationRecord
  validates :title, :content, :deadline_on, :priority, :status, presence: true
  enum priority: [:low, :middle, :high]
  enum status: [:waiting, :working, :completed]
  scope :latest_deadline, -> {order(deadline_on: :asc)}
  scope :highest_priority, -> {order(priority: :desc)}

  # scope :search, -> (search_params) do
  #   if search_params[:title]&&search_params[:status]
  #     status_search(search_params[:status])
  #     .title_search(search_params[:title])
  #   elsif search_params[:status]
  #     status_search(search_params[:status])
  #   elsif search_params[:title]
  #     title_search(search_params[:title])
  #   end
  # end

  scope :status_search, ->(status){where(status: status)}
  scope :title_search, ->(part) {where("title like ?", "%#{part}%")}
end
