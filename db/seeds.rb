date_list = ['2025/10/01', '2025/12/01', '2025/01/01', '2025/05/01', '2025/03/01', '2025/11/01', '2025/02/01',
             '2025/09/01', '2025/04/01', '2025/01/01']
priority_list = [2, 0, 2, 1, 1, 0, 1, 2, 1, 2]
status_list = [0, 2, 2, 0, 1, 1, 0, 2, 1, 2]
general_user = User.create!(name: '一般ユーザ', email: 'ippan@aaa.aa', password: '123456', admin: false)
admin_user = User.create!(name: '管理者ユーザ', email: 'kanrisha@aaa.aa', password: '123456', admin: true)

50.times do |n|
  Task.create!(title: "task_title_seed#{n + 1}", content: "task_content_seed#{n + 1}", deadline_on: date_list[n / 10],
               priority: priority_list[n / 10], status: status_list[n / 10], user_id: general_user.id)
end

50.times do |n|
  Task.create!(title: "task_title_seed#{n + 1}", content: "task_content_seed#{n + 1}", deadline_on: date_list[n / 10],
               priority: priority_list[n / 10], status: status_list[n / 10], user_id: admin_user.id)
end
