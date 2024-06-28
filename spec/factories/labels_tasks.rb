FactoryBot.define do
  factory :labels_tasks do
    association :label
    association :task
    # labels_tasks の属性を定義
    # 例: label_id, task_id
    label_id { 1 }
    task_id { 1 }
  end
end
