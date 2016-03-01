require 'nokogiri'
require 'open-uri'
require 'json'

module Scrapers
  module Stores
    class Nicolas
      NB_PAGE_STORE = 33
      NB_STORE_BY_PAGE = 9

      def run
        brand = Brand.find_by_name("Nicolas")
        brand.stores.destroy_all
        am = pm = []
        puts "Nicolas Stores is starting"
        (0..NB_PAGE_STORE).each do |page|
          puts "page n°#{page}"
          store_list = open("http://www.nicolas.com/fr/store-finder?q=75&page=#{page}")
          doc = Nokogiri::HTML(store_list, nil, 'utf-8')
          doc.css('.storeMap').each do |element|
            (0..NB_STORE_BY_PAGE).each do |i|

              store = JSON.parse(element.attribute("data-stores"))
              break unless store["store#{i}"]

              new_store = Store.create(brand_id: brand.id,name: store["store#{i}"]["displayName"], address: [store["store#{i}"]["address"] ,store["store#{i}"]["postcode"], store["store#{i}"]["town"]].join(' '))
              store_details = open("http://www.nicolas.com/#{store["store#{i}"]["urlDetail"]}")
              create_schedule(store_details, new_store.id)
              am = pm = []
            end
          end
        end
      end

      private

      def create_schedule(store_details, store_id)
        day = 0
        doc = Nokogiri::HTML(store_details, nil, 'utf-8')
        puts "Schedule #{store_id}"
        doc.css('.weekday_openings').each do |detail|
          detail.css('.ns-StoreDetails-openingsTimesDetail').each do |d|
            schedules = get_schedules(d)
            StoreSchedule.create!(store_id: store_id, day: day + 1, start_am: schedules[0] ,end_am: schedules[1] ,start_pm: schedules[2] ,end_pm: schedules[3])
            day += 1
            day = 0 if day == 7
          end
        end
      end

      def get_schedules(schedule)
        schedules = []

        start_am = end_am = start_pm = end_pm = []
        am = schedule.css('.ns-StoreDetails-openingsTimesDetailAM').text().strip.gsub(/\n\t*\s/,'-').split('-')
        pm = schedule.css('.ns-StoreDetails-openingsTimesDetailPM').text().strip.gsub(/\n\t*/,'-').split('-')
        if am.count == 1 && pm.count == 1
          schedules << am[0]
          schedules << nil
          schedules << nil
          schedules << pm[0]
        elsif am.count == 0 && pm.count == 2
          schedules << nil
          schedules << nil
          schedules << pm[0]
          schedules << pm[1]
        elsif am.count == 2 && pm.count == 0
          schedules << am[0]
          schedules << am[1]
          schedules << nil
          schedules << nil
        elsif am.count == 2 && pm.count == 2
          schedules << am[0]
          schedules << am[1]
          schedules << pm[0]
          schedules << pm[1]
        elsif am.count == 0 && pm.count == 0
          schedules[0] = schedules[1] = schedules[2] = schedules[3] = nil
        end
        return schedules
      end
    end
  end
end
