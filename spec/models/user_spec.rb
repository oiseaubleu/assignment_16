require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: '', email: 'test@aaa.aa', password: '123456', admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'test', email: '', password: '123456', admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'test', email: 'test2@aaa.aa', password: '', admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        User.create(name: 'test', email: 'test3@aaa.aa', password: '123456', admin: false)
        user2 = User.create(name: 'test2', email: 'test3@aaa.aa', password: '1234562', admin: false)

        expect(user2).not_to be_valid
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'test', email: 'test4@aaa.aa', password: '12345', admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = User.create(name: 'test', email: 'test5@aaa.aa', password: '123456', admin: false)
        expect(user).to be_valid
      end
    end
  end
end
