class User < ApplicationRecord

    # password暗号化設定
    has_secure_password validations: true

    # name, emailのnullチェック
    validates :name, presence:true, length: { maximum: 50 }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 100 }, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
end
