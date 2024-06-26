class User < ApplicationRecord
  before_destroy :check_last_admin, prepend: true
  def check_last_admin
    # 削除する対象がadminだったら
    return true unless admin
    # User.all.where(admin: true).size == 1 # 1のとき
    return true if User.all.where(admin: true).size > 1 # 1よりも大きいとき

    errors.add(:last_admin, ': 管理者が0人になるため削除できません')

    puts '最後のユーザです'
    throw :abort
  end

  has_many :tasks, dependent: :destroy
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { message: 'メールアドレスはすでに使用されています' },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6, message: 'パスワードは6文字以上で入力してください' }
end
