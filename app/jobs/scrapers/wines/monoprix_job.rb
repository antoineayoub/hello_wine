require 'scrapers/wines/monoprix'

module Scrapers
  module Wines
    class MonoprixJob < ActiveJob::Base
      queue_as :default

      def perform(*args)
        ActiveRecord::Base.transaction do
          Scrapers::Wines::Monoprix.new.run
        end
      end
    end
  end
end
