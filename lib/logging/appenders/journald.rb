require 'journald/logger'

module Logging
  module Appenders

    def self.journald(name, *args)
      if args.empty?
        return self['journald'] || ::Logging::Appenders::Journald.new(name)
      end
      ::Logging::Appenders::Journald.new(name, *args)
    end

    class Journald < ::Logging::Appender
      attr_reader :ident, :mdc, :ndc, :facility, :extra, :journal

      def initialize(name, opts = {})
        opts[:layout] ||= ::Logging::Layouts::Noop.new
        @ident = opts.fetch(:ident, name)
        @mdc = opts.fetch(:mdc, true)
        @ndc = opts.fetch(:ndc, true)
        @facility = Integer(opts.fetch(:facility, ::Syslog::Constants::LOG_USER))
        @extra = opts.fetch(:extra, {})
        @map = [
          ::Journald::LOG_DEBUG,
          ::Journald::LOG_INFO,
          ::Journald::LOG_WARNING,
          ::Journald::LOG_ERR,
          ::Journald::LOG_CRIT
        ]
        map = opts.fetch(:map, nil)
        self.map = map unless map.nil?
        @journal = ::Journald::Logger.new(ident, ::Journald::LOG_DEBUG)
        #@journal.sev_threshold = ::Journald::LOG_DEBUG
        super(name, opts)
      end

      def map=(levels)
        map = []
        levels.keys.each do |lvl|
          num = ::Logging.level_num(lvl)
          map[num] = syslog_level_num(levels[lvl])
        end
        @map = map
      end

      def close(*args)
        super(false)
      end

      private

      def syslog_level_num(level)
        case level
        when Integer; level
        when String, Symbol
          level = level.to_s.upcase
          self.class.const_get level
        else
          raise ArgumentError, "unknown level '#{level}'"
        end
      end

      def write(event)
        priority = ::Journald::LOG_DEBUG
        record = {}
        record.merge!(extra) unless extra.empty?
        record.merge!(SYSLOG_FACILITY: @facility) unless @facility.nil?
        record.merge!(Logging.mdc.context) if mdc
        if ndc
          Logging.ndc.context.each do |item|
            record.merge!(item) if item.instance_of?(Hash)
          end
        end
        if event.instance_of?(::Logging::LogEvent)
          priority = @map[event.level]
          if event.data.instance_of?(Hash)
            record.merge!(event.data)
          else
            record[:message] = @layout.format(event)
          end
        else
          record[:message] = event
        end
        record.merge!({ priority: priority })
        @journal.send(record)
        self
      rescue StandardError => err
        self.level = :off
        ::Logging.log_internal 'system journal appender have been disabled'
        ::Logging.log_internal_error(err)
        raise(err)
      end
    end
  end
end
