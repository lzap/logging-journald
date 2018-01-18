require 'logging'

log = Logging.logger['example']
log.add_appenders(Logging.appenders.journald('simple',
  ident: 'simple', # optional log ident (appender name by default)
  layout: Logging.layouts.pattern(pattern: "%m\n"), # optional layout
  mdc: true, # log mdc into custom journal fields (true by default)
  ndc: true, # log ndc hash values into custom journal fields (true by default)
  facility: ::Syslog::Constants::LOG_USER, # optional syslog facility
  extra: {}, # extra custom journal fields
  ))
log.add_appenders(Logging.appenders.stdout)
log.level = :debug

# mapped diagnostic context is logged when mdc is set to true
Logging.mdc['USERNAME'] = 'Ondra'

# logging into journal is straight-forward
log.debug "this is debug message"
log.info "a very nice little info message"
log.warn "this is your last warning"

# hash instead string is supported with arbitrary key/value pairs but
# layout is ignored in this case
log.error message: "oh no an error", akey: "a value"

# when ndc is enabled, any number of hash objects can be pushed
# and will be logged with the message
Logging.ndc << { akey: "a value" }
log.fatal "an exception occured"
Logging.ndc.clear
