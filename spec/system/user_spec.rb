require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user_second) { FactoryBot.create(:user_second) }
  let!(:admin) { FactoryBot.create(:user_admin) }

  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path

        find('input[name="user[name]"]').set('new_general_user_name')
        find('input[name="user[email]"]').set('new_general_user@xxx.xx')
        find('input[name="user[password]"]').set('123456')
        find('input[name="user[password_confirmation]"]').set('123456')
        click_button '登録する'
        # sleep 3.0
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスク一覧ページ'
      end
    end
    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        # sleep 0.5
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'ログイン機能' do
    before do
      visit new_session_path
      find('input[name="session[email]"]').set(user.email)
      find('input[name="session[password]"]').set(user.password)
      click_button 'ログイン'
    end

    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'ログインしました'
      end
      it '自分の詳細画面にアクセスできる' do
        visit user_path(user.id)
        expect(page).to have_content 'アカウント詳細ページ'
      end
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(user_second.id)
        expect(current_path).to eq tasks_path(user.id)
      end
      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe '管理者機能' do
    context '管理者がログインした場合' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'ログイン'
      end
      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_content 'ユーザ一覧'
      end
      it '管理者を登録できる' do
        visit new_admin_user_path
        find('input[name="user[name]"]').set('new_admin_user_name')
        find('input[name="user[email]"]').set('new_admin_user@xxx.xx')
        find('input[name="user[password]"]').set('123456')
        find('input[name="user[password_confirmation]"]').set('123456')
        check 'user[admin]'
        click_button '登録する'
        expect(User.find_by(name: 'new_admin_user_name').admin).to eq true
      end
      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(user_second.id)
        expect(page).to have_content '一般次郎'
      end
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(user_second)
        find('input[name="user[password]"]').set(user_second.password)
        find('input[name="user[password_confirmation]"]').set(user_second.password)
        check 'user[admin]'
        click_button '更新する'
        expect(page).to have_content 'ユーザを更新しました'
      end
      it 'ユーザを削除できる' do
        visit admin_users_path
        click_link '削除', href: admin_user_path(user_second.id)
        # 削除しますかのアラート無視したい
        expect(page.accept_confirm).to eq '本当に削除してもよろしいですか？'
        expect(page).not_to have_content '一般次郎'
      end
    end
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        # 一般ユーザ氏ログイン
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        # ユーザ一覧にいこうとして怒られる
        visit admin_users_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content '管理者以外アクセスできません'
      end
    end
  end
end
