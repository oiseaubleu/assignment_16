require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。', deadline_on: 1.day.from_now, priority: 1, status: 2)
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: 'タイトル', content: '', deadline_on: 1.day.from_now, priority: 1, status: 2)
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(title: 'タイトル', content: 'タスク内容', deadline_on: 1.day.from_now, priority: 1, status: 1)
        expect(task).to be_valid
      end
    end
  end
  describe '検索機能' do
    # テストデータを複数作成する
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title') }
    let!(:second_task) { FactoryBot.create(:second_task, title: 'second_task_title') }
    let!(:third_task) { FactoryBot.create(:third_task, title: 'third_task_title') }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it '検索ワードを含むタスクが絞り込まれる' do
        # タイトルの検索メソッドをseach_titleとしてscopeで定義した場合のコード例
        # scopeを使って定義した検索メソッドに検索ワードを挿入する
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.title_search('first')).to include(first_task)
        expect(Task.title_search('first')).not_to include(second_task)
        expect(Task.title_search('first')).not_to include(third_task)
        expect(Task.title_search('first').count).to eq 1
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it 'ステータスに完全一致するタスクが絞り込まれる' do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.status_search(0)).to include(first_task)
        expect(Task.status_search(0)).not_to include(second_task)
        expect(Task.status_search(0)).not_to include(third_task)
        expect(Task.status_search(0).count).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it '検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる' do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search({ status: 0, title: 'first' }, false, false)).to include(first_task)
        expect(Task.search({ status: 0, title: 'first' }, false, false)).not_to include(second_task)
        expect(Task.search({ status: 0, title: 'first' }, false, false)).not_to include(third_task)
        expect(Task.search({ status: 0, title: 'first' }, false, false).count).to eq 1
      end
    end
  end
end
