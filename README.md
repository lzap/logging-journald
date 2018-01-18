## Logging Journald
by Lukas Zapletal [![](https://secure.travis-ci.org/lzap/logging-journald.svg)](https://travis-ci.org/lzap/logging-journald)

* [Homepage](http://rubygems.org/gems/logging-journald)
* [Github Project](https://github.com/lzap/logging-journald)

### Description

**Logging Journald** is a plugin for logging gem - the flexible logging library for use in Ruby programs. It supports logging to system journal via journald-logger and journald-native gems.

### Installation

```
gem install logging-journald
```

### Examples

Use MDC to send arbitrary key/value pairs to system journal:

```ruby
require 'logging'

log = Logging.logger['app']
log.add_appenders(Logging.appenders.journald('myservice'))

# use mapped diagnostic context to send custom fields
Logging.mdc['signed_user'] = 'Ondra'
logger.debug "blah blah"
```

The example above will be rendered as:

```
# journalctl -o verbose
  MESSAGE=blah blah
  SYSLOG_FACILITY=8
  SIGNED_USER=Ondra
  PRIORITY=2
  SYSLOG_IDENTIFIER=myapp
  _PID=25979
  _TRANSPORT=journal
  _UID=1000
  _GID=1000
  _MACHINE_ID=xxx
  _HOSTNAME=xxx
  _BOOT_ID=xxx
  ...
```

Mapped diagnostic contexts are great for global values like logged user, request or session id. There are two more options to send arbitrary key/value pairs:

```ruby
require 'logging'

log = Logging.logger['app']
log.add_appenders(Logging.appenders.journald('myservice'))

# nested diagnostic context is a stack of values and
# it can be used but only hashes are taken into account
begin
  Logging.ndc << { exception: err, backtrace: err.backtrace }
  log.fatal "an exception occured"
ensure
  Logging.ndc.clear
end

# hash can be provided instead of string but in this case
# layout cannot be used to format message in the system journal
log.info message: "this must be called 'message'", akey: "a value"
```

There are some examples in the [examples folder](/examples).

### License

The MIT License - see the [LICENSE](/LICENSE) file for the full text.
