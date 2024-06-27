class User < ApplicationRecord
  before_update :edit_last_admin, prepend: true
  before_destroy :check_last_admin, prepend: true
  def check_last_admin
    # 削除する対象がadminじゃなければなにもしない
    return true unless admin
    # 2人以上のadminがいるときもなにもしない
    return true if User.all.where(admin: true).size > 1

    errors.add(:last_admin, '管理者が0人になるため削除できません')

    puts '最後のユーザです'
    throw :abort
  end

  def edit_last_admin
    # binding.irb
    # puts "!!!!!!!#{will_save_change_to_admin?}!!!!!"
    # 削除する対象がadminじゃなければなにもしない
    # return true unless admin
    # 2人以上のadminがいるときもなにもしない
    return true if User.all.where(admin: true).size > 1

    # adminの欄以外が変わっても何もしない
    ## これから変えようとしている対象
    # admin_chan = User.where(admin: true)[0]
    ## これから変える予定の値がtrueなら何もしない
    ## これから変える予定の欄がadminである　かつ　true ->falseであること
    if will_save_change_to_admin? && attribute_change_to_be_saved(:admin)[1] == false
      # #falseだったら全力で止める
      # puts "!!!!!!!#{will_save_change_to_admin?}!!!!!"
      errors.add(:last_admin_edit, '管理者が0人になるため権限を変更できません')
      throw :abort
    else
      true
    end
  end
  has_many :labels
  has_many :tasks, through: :labels, dependent: :destroy
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { message: 'メールアドレスはすでに使用されています' },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6, message: 'パスワードは6文字以上で入力してください' }
end
