module Logging
  module Plugins
    module Journald
      extend self

      VERSION ||= '1.0.0'.freeze

      def initialize_journald
        require File.expand_path('../../layouts/noop', __FILE__)
        require File.expand_path('../../appenders/journald', __FILE__)
      end
    end
  end
end
