## Logging Journald
by Lukas Zapletal [![](https://secure.travis-ci.org/lzap/logging-journald.svg)](https://travis-ci.org/lzap/logging-journald)

* [Homepage](http://rubygems.org/gems/logging-journald)
* [Github Project](https://github.com/lzap/logging-journald)

### Description

**Logging Journald** is a plugin for [logging gem](https://github.com/TwP/logging) - the flexible logging library for use in Ruby programs. It supports logging to system journal via journald-logger and journald-native gems.

### Installation

```
gem install logging-journald
```

The gem provides journald appender and noop layout that does no formatting since core library does not provide such a layout. Apppender options are:

* name - name of the appender (required)
* ident - optional log ident (appender name by default)
* layout - optional layout (no formatting by default)
* mdc - log mdc into custom journal fields (true by default)
* ndc - log ndc hash values into custom journal fields (true by default)
* facility - optional syslog facility rendered as SYSLOG_FACILITY (LOG_USER (8) by default)
* extra - extra custom journal fields as hash

All custom fields are converted to uppercase by joudnald automatically, for more details [visit official documentation](https://www.freedesktop.org/software/systemd/man/systemd.journal-fields.html).

### Examples

Use MDC to send arbitrary key/value pairs to system journal:

```ruby
require 'logging'

log = Logging.logger['app']
log.add_appenders(Logging.appenders.journald('myservice'))

# use mapped diagnostic context to send custom fields
Logging.mdc['signed_user'] = 'Ondra'
log.debug "blah blah"
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
