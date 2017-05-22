module Sched
  class Client
    attr_accessor :conference, :api_key
    def initialize(conference, api_key)
      @conference = conference
      @api_key = api_key
    end

    def event(session_key)
      event = Sched::Event.new(session_key, self)
      event = events.find { |e| e.session_key == session_key } if event.exists?
      event
    end

    def events
      @events ||= parse_sessions(CSV.parse(request("session/list", nil, :get)))
    end

    def api_url
      "https://#{@conference}.sched.org/api"
    end

    def request(path, data = {}, method = :post)
      data ||= {}
      data[:api_key] = @api_key
      if method == :post
        post_request(path, data)
      elsif method == :get
        get_request(path, data)
      end
    end

    private

    def byte_order_mark
      "\xEF\xBB\xBF".force_encoding("UTF-8")
    end

    def curl_client(path)
      c = Curl::Easy.new("#{api_url}/#{path}")
      c.headers["User-Agent"] = "sched-gem"
      c
    end

    def encoded(str)
      str.force_encoding("UTF-8").gsub(byte_order_mark, "")
    end

    def full_url(path)
      "#{api_url}/#{path}"
    end

    def get_request(path, data)
      get_attributes = data.map { |key, value| "#{key}=#{value}" }.join("&")
      c = curl_client("#{path}?#{get_attributes}")
      c.perform
      encoded(c.body_str)
    end

    def parse_attributes(attributes)
      return [] unless attributes
      attributes.map do |a|
        a.gsub(/^event_/, "session_").to_sym
      end
    end

    def parse_sessions(results)
      attributes = parse_attributes(results.shift)
      results.map do |row|
        row_hash = {}
        attributes.each_with_index do |a, i|
          row_hash[a] = row[i]
        end
        Sched::Event.new(row_hash[:session_key], self).configure(row_hash)
      end
    end

    def post_request(path, data)
      post_fields = data.map do |key, value|
        Curl::PostField.content(key.to_s, value)
      end
      c = curl_client(path)
      c.http_post(post_fields)
      encoded(c.body_str)
    end
  end
end
