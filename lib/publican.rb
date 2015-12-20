module Publican
  NoListenersError = Class.new(StandardError)

  def on(*events, &block)
    @_publican_listeners ||= {}

    events.each do |event|
      (@_publican_listeners[event] ||= []) << block
    end

    self
  end

  protected

  def publish(event, *args)
    listeners = @_publican_listeners && @_publican_listeners[event] || []
    listeners.each { |listener| listener.call(*args) }
    !listeners.empty?
  end

  def publish!(event, *args)
    publish(event, *args) or raise NoListenersError, "No listeners are listening for event #{event}"
  end
end
