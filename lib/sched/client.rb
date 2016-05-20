module Sched
  class Client
    attr_accessor :conference, :api_key
    def initialize(conference, api_key)
      @conference, @api_key = conference, api_key
    end

    def event(session_key)
      event = Sched::Event.new(session_key, self)
      if event.exists?
        event = self.events.select{|e| e.session_key == session_key}.first
      end
      event
    end

    def events
      unless @events
        results = CSV.parse(request('session/list', nil, :get))

        attributes = results.shift.map do |a|
          a.strip.gsub(/[\u0080-\u00ff]/, "").gsub(/^event_/, "session_").to_sym
        end

        @events = results.map do |row|
          row_hash = {}
          attributes.each_with_index do |a, i|
            row_hash[a] = row[i]
          end
          Sched::Event.new(row_hash[:session_key], self).configure(row_hash)
        end
      end
      @events
    end

    def api_url
      "http://#{@conference}.sched.org/api"
    end

    def request(sub_url, data={}, method = :post)
      data ||= {}
      data.merge!({:api_key => @api_key})
      url = "#{api_url}/#{sub_url}"
      output = nil
      if method == :post
        post_fields = data.map{|key, value| Curl::PostField.content(key.to_s, value)}
        c = Curl::Easy.new(url)
        c.headers["User-Agent"] = "sched-gem"
        c.http_post(post_fields)
        output = c.body_str
      elsif method == :get
        get_attributes = data.map{|key, value| "#{key}=#{value}" }.join("&")
        c = Curl::Easy.new("#{url}?#{get_attributes}")
        c.headers["User-Agent"] = "sched-gem"
        c.perform
        output = c.body_str
      end
      output
    end
  end
end
