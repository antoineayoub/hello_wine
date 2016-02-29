class Store < ActiveRecord::Base
  has_many :store_schedules, dependent: :destroy
  belongs_to :brand
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  scope :filter_by_opening, -> (brand_id) do
    distinct.joins(:store_schedules).joins(:brand).where("start_am < ? AND end_pm > ? AND day = ?", Time.now, Time.now, Date.today.cwday).where(brand: brand_id)
  end
  #SELECT DISTINCT COUNT(DISTINCT "stores"."id") FROM "stores"
  #INNER JOIN "store_schedules" ON "store_schedules"."store_id" = "stores"."id"
  #INNER JOIN "brands" ON "brands"."id" = "stores"."brand_id"
  #WHERE (start_am < '2016-02-29 20:10:29.964357' AND end_pm > '2016-02-29 20:10:29.964364' AND day = 1) AND (brand_id = 1)

  # def self.opened(brand_id)
  #   store = Store.distinct.joins(:store_schedules).joins(:brand).where("start_am < ? AND end_pm > ? AND day = ?", Time.now, Time.now, Date.today.cwday).where(brand: brand_id)

  # end
end
