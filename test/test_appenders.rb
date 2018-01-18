require 'logging'
require 'test/unit'
require 'mocha/test_unit'

Logging.initialize_plugins

module TestLogging
  module TestAppenders
    class TestJournald < Test::Unit::TestCase
      def setup
        @log = Logging.logger['test']
        @log.clear_appenders
        @log.level = :debug
      end

      def setup_appender(*args)
        @appender = Logging.appenders.journald('simple', *args)
        @log.add_appenders(@appender)
      end

      def test_initialize
        setup_appender
        assert_equal "test", @log.name
        assert_equal 1, @log.appenders.size
      end

      def test_simple_debug_line
        setup_appender
        @appender.journal.expects(:send).with(has_entries(message: "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_DEBUG)).once.returns(true)
        @log.debug "test"
      end

      def test_simple_debug_line_level_info
        setup_appender
        @log.level = :info
        @appender.journal.expects(:send).with(has_entries(message: "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_DEBUG)).never.returns(true)
        @log.debug "test"
      end

      def test_simple_info_line
        setup_appender
        @appender.journal.expects(:send).with(has_entries(message: "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_INFO)).once.returns(true)
        @log.info "test"
      end

      def test_simple_warning_line
        setup_appender
        @appender.journal.expects(:send).with(has_entries(message: "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_WARNING)).once.returns(true)
        @log.warn "test"
      end

      def test_simple_error_line
        setup_appender
        @appender.journal.expects(:send).with(has_entries(message: "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_ERR)).once.returns(true)
        @log.error "test"
      end

      def test_simple_fatal_line
        setup_appender
        @appender.journal.expects(:send).with(has_entries(message: "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_CRIT)).once.returns(true)
        @log.fatal "test"
      end

      def test_simple_debug_line_as_hash
        setup_appender
        @appender.journal.expects(:send).with(has_entries("message" => "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_DEBUG)).once.returns(true)
        @log.debug "message" => "test"
      end

      def test_simple_debug_line_as_hash_with_layout
        setup_appender(layout: Logging.layouts.pattern(pattern: "X %m X"))
        @appender.journal.expects(:send).with(has_entries("message" => "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_DEBUG)).once.returns(true)
        @log.debug "message" => "test"
      end

      def test_simple_info_line_with_mdc
        setup_appender
        Logging.mdc['test'] = 'value'
        @appender.journal.expects(:send).with(has_entries(message: "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_INFO, "test" => "value")).once.returns(true)
        @log.info "test"
      ensure
        Logging.mdc.clear
      end

      def test_simple_info_line_with_ndc
        setup_appender
        Logging.ndc << { test: "value" }
        @appender.journal.expects(:send).with(has_entries(message: "test", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_INFO, test: "value")).once.returns(true)
        @log.info "test"
      ensure
        Logging.ndc.clear
      end

      def test_simple_info_line_with_layout_mdc_ndc
        setup_appender(layout: Logging.layouts.pattern(pattern: "%m %X{test1} %x"))
        Logging.mdc['test1'] = 'value'
        Logging.ndc << { "test2" => "value" }
        @appender.journal.expects(:send).with(has_entries(message: "test value {\"test2\"=>\"value\"}", SYSLOG_FACILITY: 8, priority: ::Journald::LOG_INFO, "test1" => "value", "test2" => "value")).once.returns(true)
        @log.info "test"
      ensure
        Logging.mdc.clear
        Logging.ndc.clear
      end
    end
  end
end

