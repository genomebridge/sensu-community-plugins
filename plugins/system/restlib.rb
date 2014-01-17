
def get_job_id(node_id, basicpass, gateway)
	require 'rest-client'
	response = RestClient.post 'https://#{basicpass}:x@#{gateway}/cmi-overlord-external/api/docker/node/#{node_id}/jobInfo', {:accept => :json}      
	if response.code==200
		JSON.parse(response)
	else
		JSON.parse({"currentJobId":"Unknown"})
end
