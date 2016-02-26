require 'scrapers/stores/nicolas'

module Scrapers
  module Stores
    class NicolasJob < ActiveJob::Base
      queue_as :default

      def perform(*args)
        Scrapers::Stores::Nicolas.new.run
      end
    end
  end
end
