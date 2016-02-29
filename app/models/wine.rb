class Wine < ActiveRecord::Base
  belongs_to :brand

  has_many :external_ratings, dependent: :destroy
  has_many :user_ratings,     dependent: :destroy

  mount_uploader :photo, PhotoUploader

  scope :filter_by_location, -> (latitude, longitude) do
    stores = Store.near([latitude, longitude], 0.6, units: :km)
    distinct.joins(brand: :stores).where(stores: { id: stores.map(&:id) }) # map { |x| x.id }
  end
   #SELECT DISTINCT "wines".* FROM "wines"
    #INNER JOIN "brands" ON "brands"."id" = "wines"."brand_id"
    #INNER JOIN "stores" ON "stores"."brand_id" = "brands"."id"
    #WHERE "stores"."id" IN (4615, 4589, 4666, 4692)

  scope :filter_by_color, -> (color) { where(color: color) }

  scope :filter_by_pairing, -> (pairing) do
    condition = <<~HEREDOC
      (pairing_1 IS NULL OR pairing_1 = :pairing)
      OR pairing_2 = :pairing
      OR pairing_3 = :pairing
      OR pairing_4 = :pairing
    HEREDOC

    where(condition, pairing: pairing)
  end

  scope :filter_by_price, -> (price) do
    case price
    when 'less-10'
      where('price <= 10')
    when '10-20'
      where('price >= 10 AND price <= 20')
    when 'more-20'
      where('price >= 20')
    end
  end

  def nearest(latitude,longitude)
    stores_closed = []
    stores = Store.all
    Brand.all.each do |brand|
      stores = stores.filter_by_opening(brand.id)
      store = brand.stores.near([latitude, longitude], 0.6, units: :km, :order => "distance").first
      stores_closed << {
        store: store,
        distance: Geocoder::Calculations.distance_between([latitude,longitude], store, {units: :km})
      }
    end
    stores_closed.sort_by! { |hash| hash[:distance]}
    selected_store = stores_closed.first
  end
end
