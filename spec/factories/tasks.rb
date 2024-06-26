# 「FactoryBotを使用します」という記述

FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する。' }
    deadline_on { 10.day.from_now }
    priority { 1 }
    status { 0 }
    user_id { 1 }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  factory :second_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { 5.day.from_now }
    priority { 2 }
    status { 1 }
    user_id { 1 }
  end

  factory :third_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { 3.day.from_now }
    priority { 0 }
    status { 2 }
    user_id { 1 }
  end
end
