class Brand < ActiveRecord::Base
  has_many :stores, dependent: :destroy
  has_many :wines, dependent: :destroy
end
