module V1
	class Base < API
	    version "v1", :using => :path

	    helpers do
			def clean_params(params)
				ActionController::Parameters.new(params)
			end

			def authenticate!
				error!('Unauthorized. Invalid or expired token.', 401) unless current_user
			end

			def current_user
				token = ApiKey.where(access_token: request.headers["Authorization"]).first
				if token && !token.expired?
					@current_user = token.user
				else
					false
				end
			end

		end

	    mount PetAPI
	    mount AuthAPI
	end
end