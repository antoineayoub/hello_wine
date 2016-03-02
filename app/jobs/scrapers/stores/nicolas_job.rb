require 'scrapers/stores/nicolas'

module Scrapers
  module Stores
    class NicolasJob < ActiveJob::Base
      queue_as :default

      def perform(*args)
        ActiveRecord::Base.transaction do
          Scrapers::Stores::Nicolas.new.run
        end
      end
    end
  end
end
