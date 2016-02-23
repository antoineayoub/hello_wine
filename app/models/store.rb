class Store < ActiveRecord::Base
  has_many :schedules, dependent: :destroy
  has_many :wines, dependent: :destroy
end
