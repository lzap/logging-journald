module Logging::Layouts

  def self.noop(*args)
    return ::Logging::Layouts::Noop if args.empty?
    ::Logging::Layouts::Noop.new(*args)
  end

  class Noop < ::Logging::Layout
    def format(event)
      event.data.to_s
    end
  end
end
