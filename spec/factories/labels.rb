FactoryBot.define do
  factory :label do
    name { 'label10' }
    user_id { 1 }
  end

  factory :second_label, class: Label do
    name { 'label11' }
    user_id { 1 }
  end
end
