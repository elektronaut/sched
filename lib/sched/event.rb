module Sched
  class Event
    SCHED_ATTRIBUTES = [
      # Required
      :session_key, :name, :session_start, :session_end, :session_type,
      # Optional
      :session_subtype, :description, :panelists, :url, :media_url, :venue,
      :address, :map, :tags, :active
    ].freeze
    SCHED_ATTRIBUTES.each { |attribute| attr_accessor attribute }
    attr_accessor :client

    def initialize(session_key, client = nil)
      @session_key = session_key
      @client = client
    end

    def get_attribute(key)
      send(key.to_s)
    end

    def configure(options = {})
      options.each do |key, value|
        send("#{key}=", value) if SCHED_ATTRIBUTES.include?(key)
      end
      self
    end

    def data
      data = {}
      SCHED_ATTRIBUTES.each do |attribute|
        next if get_attribute(attribute).nil?
        value = get_attribute(attribute)
        value = "Y" if value == true
        value = "N" if value == false
        data[attribute] = value
      end
      data
    end

    def save
      if exists?
        update
      else
        create
      end
    end

    def create
      client.request("session/add", data)
    end

    def update
      client.request("session/mod", data)
    end

    def exists?
      client.events.map(&:session_key).include?(session_key) ? true : false
    end

    def destroy
      return unless exists?
      client.request("session/del", session_key: session_key)
    end
  end
end
