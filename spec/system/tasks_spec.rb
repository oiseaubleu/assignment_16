require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  # ユーザのテストデータを作成
  let!(:user) { FactoryBot.create(:user) }
  let!(:user_second) { FactoryBot.create(:user_second) }
  let!(:label_created_by_user) { Label.create(name: 'label_name', user_id: user.id) }
  before do
    visit new_session_path
    find('input[name="session[email]"]').set(user.email)
    find('input[name="session[password]"]').set(user.password)
    click_button 'ログイン'
  end
  ######################################
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        # Task.create!(title: '書類作成', content: '企画書を作成する。')
        FactoryBot.create(:task, content: 'content1', created_at: Time.zone.now, user_id: user.id)
        visit tasks_path
        expect(page).to have_content 'content1'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe '一覧表示機能' do
    let!(:first_task) { FactoryBot.create(:task, content: 'content1', created_at: Time.zone.now, user_id: user.id) }
    let!(:second_task) do
      FactoryBot.create(:second_task, content: 'content2', created_at: 1.day.from_now, user_id: user.id)
    end
    let!(:third_task) { FactoryBot.create(:third_task, content: 'content3', created_at: 1.day.ago, user_id: user.id) }

    before do
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が作成日時の降順で表示される' do
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        expect(page).to have_content 'メール送信'

        #  within ".tasks" do
        #   task_contents = all(".task-content").map(&:text)
        #   expect(task_contents).to eq %w(content2 content1 content3)
        # end
        tasks = all('tbody tr')
        # binding.irb
        expect(tasks[0].text).to include('content2')
        expect(tasks[1].text).to include('content1')
        expect(tasks[2].text).to include('content3')
      end

      context '新たにタスクを作成した場合' do
        it '新しいタスクが一番上に表示される' do
          tasks = all('tbody tr')
          expect(tasks[0].text).to include('content2')
        end
      end

      # #STEP3
      describe 'ソート機能' do
        context '「終了期限」というリンクをクリックした場合' do
          it '終了期限昇順に並び替えられたタスク一覧が表示される' do
            # allメソッドを使って複数のテストデータの並び順を確認する
            click_on '終了期限'
            sleep 0.2
            tasks = all('tbody tr')
            expect(tasks[0].text).to have_content 'content3'
            expect(tasks[1].text).to have_content 'content2'
            expect(tasks[2].text).to have_content 'content1'
          end
        end
        context '「優先度」というリンクをクリックした場合' do
          it '優先度の高い順に並び替えられたタスク一覧が表示される' do
            # allメソッドを使って複数のテストデータの並び順を確認する
            click_on '優先度'
            sleep 0.2
            tasks = all('tbody tr')
            expect(tasks[0].text).to have_content 'content2'
            expect(tasks[1].text).to have_content 'content1'
            expect(tasks[2].text).to have_content 'content3'
          end
        end
      end
      describe '検索機能' do
        context 'タイトルであいまい検索をした場合' do
          it '検索ワードを含むタスクのみ表示される' do
            # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
            find('input[name="search[title]"]').set('メール')
            find('#search_task').click
            expect(page).to have_content 'content2'
            expect(page).to have_content 'content3'
            expect(page).not_to have_content 'content1'
          end
        end
        context 'ステータスで検索した場合' do
          it '検索したステータスに一致するタスクのみ表示される' do
            # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
            select '未着手', from: 'search[status]'
            find('#search_task').click
            expect(page).to have_content 'content1'
            expect(page).not_to have_content 'content2'
          end
        end
        context 'タイトルとステータスで検索した場合' do
          it '検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される' do
            # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
            select '完了', from: 'search[status]'
            find('input[name="search[title]"]').set('メール')
            find('#search_task').click
            expect(page).to have_content 'content3'
            expect(page).not_to have_content 'content1'
          end
        end
      end
    end

    describe '詳細表示機能' do
      context '任意のタスク詳細画面に遷移した場合' do
        it 'そのタスクの内容が表示される' do
          # テストで使用するためのタスクを登録

          task = FactoryBot.create(:task, content: 'content1', created_at: Time.zone.now, user_id: user.id)
          visit task_path(task)
          # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
          expect(page).to have_content 'content1'
          # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
        end
      end
    end

    # #STEP3
    describe '検索機能' do
      context 'ラベルで検索をした場合' do
        it 'そのラベルの付いたタスクがすべて表示される' do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          5.times do |t|
            Task.create(title: "task_title_#{t + 2}", content: "task_content_#{t + 2}", deadline_on: Date.today,
                        priority: 0, status: 0, user_id: user.id)
            task = Task.create(title: "task_title_#{t + 7}", content: "task_content_#{t + 7}", deadline_on: Date.today,
                               priority: 0, status: 0, user_id: user.id)
            task.labels << label_created_by_user
          end
          visit tasks_path
          sleep 0.5
          find('select[name="search[label]"]').find("option[value='#{label_created_by_user.id}']").select_option
          click_button '検索'
          sleep 0.5
          expect(page).to have_content 'task_title_7'
          expect(page).to have_content 'task_title_8'
          expect(page).to have_content 'task_title_9'
          expect(page).to have_content 'task_title_10'
          expect(page).to have_content 'task_title_11'
          expect(page).not_to have_content 'task_title_2'
          expect(page).not_to have_content 'task_title_3'
          expect(page).not_to have_content 'task_title_4'
          expect(page).not_to have_content 'task_title_5'
          expect(page).not_to have_content 'task_title_6'

          # task0 = FactoryBot.create(:task, content: 'content1', created_at: Time.zone.now, user_id: user.id)
          # task1 = FactoryBot.create(:task, content: 'content2', created_at: Time.zone.now, user_id: user.id)
          # label0 = FactoryBot.create(:label, user_id: user.id)
          # label2 = FactoryBot.create(:second_label, user_id: user.id)
          # task2 = FactoryBot.create(:task, user_id: user.id) do |task|
          #   FactoryBot.create_list(:label, 1, tasks: [task], user_id: user.id)
          # end
          # # binding.irb
          # visit tasks_path
          # find('select[name="search[label]"]').find("option[value='#{label_created_by_user.id}']").select_option
          # click_button '検索'

          # # find('select[name="search[label]"]').find("option[value='#{ここに入れたかった}']").select_option
          # # find('select[name="search[label]"]').find("option[value='#{label.id}']").select_option
          # expect(page).to have_content '企画書を作成する。'
          # expect(page).not_to have_content 'content2'
        end
      end
    end
  end
end
