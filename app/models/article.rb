class Article < ApplicationRecord

    # titleとcontentsのnullチェック
    # validates :title, presence: true, length: { maximum: 10 }
    validates :title, length: { maximum: 100 }
    # validates :contents, presence: true, length: { maximum: 10 }
    validates :contents, length: { maximum: 100 }

    # 空欄の時の日本語メッセージ
    validate :prohibit_blank

    def self.getArticles(isMember = false)
        if (isMember)
          Article.all
        else
          Article.where(memberOnly: false)
        end
    end

    def prohibit_blank
      if title.blank?
        errors[:base] << "タイトルは必ず入力してください"
      end
      
      if contents.blank?
        errors[:base] << "投稿内容は必ず入力してください"
      end
    end

end
