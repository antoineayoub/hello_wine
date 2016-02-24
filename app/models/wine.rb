class Wine < ActiveRecord::Base
  belongs_to :brand
  has_many :external_ratings, dependent: :destroy
  has_many :user_ratings, dependent: :destroy

  mount_uploader :photo, PhotoUploader
end
