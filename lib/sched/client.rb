module Sched
	class Client
		attr_accessor :conference, :api_key
		def initialize(conference, api_key)
			@conference, @api_key = conference, api_key
		end
		
		def event(event_key)
			event = Sched::Event.new(event_key, self)
			if event.exists?
				event = self.events.select{|e| e.event_key == event_key}.first
			end
			event
		end
		
		def events
			unless @events
				results = FasterCSV.parse(request('event/list', nil, :get))
				attributes = results.shift.map{|a| a.to_sym}
				@events = results.map do |row|
					row_hash = {}
					attributes.each_with_index do |a, i|
						row_hash[a] = row[i]
					end
					event = Sched::Event.new(row_hash[:event_key], self).configure(row_hash)
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
				c = Curl::Easy.http_post(url, post_fields)
				output = c.body_str
			elsif method == :get
				get_attributes = data.map{|key, value| "#{key}=#{value}" }.join("&")
				c = Curl::Easy.perform("#{url}?#{get_attributes}")
				output = c.body_str
			end
			output
		end
	end
end