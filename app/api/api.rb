class API < Grape::API
	# use Rack::JSONP
	version 'v1', using: :path
    format :json
    prefix :api
    mount V1::Base
end