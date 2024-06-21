50.times do |n|
  Task.create!(title: "task_title_seed#{n+1}", content: "task_content_seed#{n+1}")
end