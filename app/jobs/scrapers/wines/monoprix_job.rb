require 'scrapers/wines/monoprix'

module Scrapers
  module Wines
    class MonoprixJob < ActiveJob::Base
      queue_as :default

      def perform(*args)
        Scrapers::Wines::Monoprix.new.run
      end
    end
  end
end
