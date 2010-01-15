module Sched
	class Event
		SCHED_ATTRIBUTES = [
			# Required
			:event_key, :name, :event_start, :event_end, :event_type,
			# Optional
			:event_subtype, :description, :panelists, :url, :media_url, :venue, :address, :map, :tags, :active
		]
		SCHED_ATTRIBUTES.each{ |attribute| attr_accessor attribute }
		attr_accessor :client

		def initialize(event_key, client=nil)
			@event_key = event_key
			@client = client
		end
		
		def get_attribute(key)
			self.send("#{key}")
		end

		def configure(options={})
			options.each do |key, value|
				if SCHED_ATTRIBUTES.include?(key)
					self.send("#{key.to_s}=", value)
				end
			end
			self
		end
		
		def data
			data = {}
			SCHED_ATTRIBUTES.each do |attribute|
				unless self.get_attribute(attribute) === nil
					value = self.get_attribute(attribute)
					value = 'Y' if value === true
					value = 'N' if value === false
					data[attribute] = value
				end
			end
			data
		end
		
		def save
			if self.exists?
				self.update
			else
				self.create
			end
		end

		def create
			self.client.request('event/add', self.data)
		end
		
		def update
			self.client.request('event/mod', self.data)
		end
		
		def exists?
			client.events.map{|e| e.event_key}.include?(self.event_key) ? true : false
		end
		
		def destroy
			self.client.request('event/del', {:event_key => self.event_key})
		end
	end
end