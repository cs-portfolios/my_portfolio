# 投稿機能モデル ユーザーといいねとコメントに紐付け
class Post < ApplicationRecord
  validates :body, presence: true, length: {maximum: 1000}
  validates :user_id, presence: true

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  mount_uploader :image, ImageUploader

  def self.search(search)
    if search
      Post.where(['body LIKE ?', "%#{search}%"])
    else
      all
    end
  end
end
