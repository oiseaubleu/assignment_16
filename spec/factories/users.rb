FactoryBot.define do
  # 一般社員
  factory :user do
    name { '一般' }
    email { 'general@xx.xx' }
    password { '123456' }
    admin { false }
  end
  # 一般社員２
  factory :user_second, class: User do
    name { '一般次郎' }
    email { 'general2@xx.xx' }
    password { '123456' }
    admin { false }
  end
  # 管理者
  factory :user_admin, class: User do
    name { '管理者' }
    email { 'admin@xx.xx' }
    password { '123456' }
    admin { true }
  end
end
