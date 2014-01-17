def get_job_id(node_id, basicpass, gateway)
	require 'rest-client'
	begin
		response = RestClient.post "https://"+basicpass+":x@"+gateway+"/cmi-overlord-external/api/docker/node/"+node_id+"/jobInfo", {:accept => :json}      
		jsonres = JSON.parse(response)
		if jsonres.empty?
			JSON.parse('{"id":"Unknown","task":"UnknownTask"}')
		else
			jsonres
		end	
	rescue => e
		JSON.parse('{"id":"Unknown","task":"UnknownTask"}')
	end
end
