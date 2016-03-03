class Wine < ActiveRecord::Base
  belongs_to :brand

  has_many :external_ratings, dependent: :destroy
  has_many :user_ratings,     dependent: :destroy

  mount_uploader :photo, PhotoUploader

  scope :filter_by_location, -> (latitude, longitude) do
    stores = Store.near([latitude, longitude], 1, units: :km)

    stores = stores.joins(:store_schedules).where("start_am <= ? AND end_pm >= ? AND day = ?", Time.now, Time.now, Date.today.cwday)

    distinct.joins(brand: :stores).where(stores: { id: stores.map(&:id) })# map { |x| x.id }
  end
   #SELECT DISTINCT "wines".* FROM "wines"
    #INNER JOIN "brands" ON "brands"."id" = "wines"."brand_id"
    #INNER JOIN "stores" ON "stores"."brand_id" = "brands"."id"
    #WHERE "stores"."id" IN (4615, 4589, 4666, 4692)

  scope :filter_by_external_ratings, -> do
    joins(:external_ratings)
  end

  scope :filter_by_color, -> (color) { where(color: color) }

  scope :filter_by_pairing, -> (pairing) do
    condition = <<~HEREDOC
      (wines.pairing_1 IS NULL OR wines.pairing_1 = :pairing)
      OR wines.pairing_2 = :pairing
      OR wines.pairing_3 = :pairing
      OR wines.pairing_4 = :pairing
      OR wines.pairing_5 = :pairing
    HEREDOC

    where(condition, pairing: pairing)
  end

  scope :filter_by_price, -> (price) do
    case price
    when 'less-10'
      where('wines.price <= 10')
    when '10-20'
      where('wines.price >= 10 AND wines.price <= 20')
    when 'more-20'
      where('wines.price >= 20')
    end
  end

  def nearest(latitude,longitude)
    stores_closed = []
    stores = Store.all
    Brand.all.each do |brand|
      stores = stores.filter_by_opening(brand.id)
      unless stores.empty?
        store = brand.stores.near([latitude, longitude], 0.6, units: :km, :order => "distance").first
        stores_closed << {
          store: store,
          distance: (Geocoder::Calculations.distance_between([latitude,longitude], store, {units: :km}) * 1000).round
        }
      end
    end
    stores_closed.sort_by! { |hash| hash[:distance]}
    selected_store = stores_closed.first
  end

  def self.find_wines(latitude,longitude,color,price,pairing)
    wine_list = Wine.all

    ##All wines whitch have an external rating
    wine_list = wine_list.filter_by_external_ratings

    ##All the wines in store less than 1km
    wine_list = wine_list.filter_by_location(latitude, longitude)

    ##Filter color
    wine_list = wine_list.filter_by_color(color) unless color.nil?

    ##Filter price
    wine_list = wine_list.filter_by_price(price) unless price.nil?

    ##Filter pairing
    wine_list = wine_list.filter_by_pairing(pairing) unless pairing.nil?

    return wine_list
  end

end
