class Task < ApplicationRecord
  validates :title, :content, :deadline_on, :priority, :status, presence: true
  enum priority: [:low, :middle, :high]
  enum status: [:waiting, :working, :completed]
  # scope :latest_deadline, -> {order(deadline_on: :asc)}
  # scope :highest_priority, -> {order(priority: :desc)}
  # テーブルヘッダーの「終了期限」をクリックした際、終了期限の昇順にソートすること
  # テーブルヘッダーの「優先度」をクリックした際、優先度の高い順にソートすること

end
