class Store < ActiveRecord::Base
  has_many :store_schedules, dependent: :destroy
  belongs_to :brand
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
