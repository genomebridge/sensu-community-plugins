def get_job_id(node_id, basicpass, gateway)
	require 'rest-client'
	begin
		response = RestClient.post "https://"+basicpass+":x@"+gateway+"/cmi-overlord-external/api/docker/node/"+node_id+"/jobInfo", {:accept => :json}      
		JSON.parse(response)
	rescue => e
		JSON.parse('{"currentJobId":"Unknown","task":"UnknownTask"}')
	end
end
