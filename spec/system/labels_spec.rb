require 'rails_helper'
RSpec.describe 'ラベル管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  before do
    visit new_session_path
    find('input[name="session[email]"]').set(user.email)
    find('input[name="session[password]"]').set(user.password)
    click_button 'ログイン'
  end

  describe '登録機能' do
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        FactoryBot.create(:label, user_id: user.id)
        visit labels_path
        expect(page).to have_content 'label10'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        FactoryBot.create(:label, user_id: user.id)
        FactoryBot.create(:second_label, user_id: user.id)
        visit labels_path
        expect(page).to have_content 'label10'
        expect(page).to have_content 'label11'
      end
    end
  end
end
