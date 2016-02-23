class Wine < ActiveRecord::Base
  belongs_to :store
  has_many :external_ratings, dependent: :destroy
  has_many :user_ratings, dependent: :destroy
end
