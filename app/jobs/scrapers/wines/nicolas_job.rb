require 'scrapers/wines/nicolas'

module Scrapers
  module Wines
    class NicolasJob < ActiveJob::Base
      queue_as :default

      def perform(*args)
        ActiveRecord::Base.transaction do
          Scrapers::Wines::Nicolas.new.run
        end
      end
    end
  end
end
