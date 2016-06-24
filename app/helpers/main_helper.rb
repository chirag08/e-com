module MainHelper
	def search_item(data,id)
		data.keys.each do |a|
			data[a].each do |c|
				if c["id"].to_s == id
					return c;
				end 
			end
		end 
	end

end
