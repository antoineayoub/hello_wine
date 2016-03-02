require 'scrapers/stores/monoprix'

module Scrapers
  module Stores
    class MonoprixJob < ActiveJob::Base
      queue_as :default

      def perform(*args)
        ActiveRecord::Base.transaction do
          Scrapers::Stores::Monoprix.new.run
        end
      end
    end
  end
end
