class Store < ActiveRecord::Base
  has_many :store_schedules, dependent: :destroy
  belongs_to :brand
end
