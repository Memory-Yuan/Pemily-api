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
				else false end
			end

			def correct_pet
				@correct_pet = @current_user.pets.find_by(id: params[:pet_id])
			end

			def correct_pet!
				authenticate!
				error!('Unauthorized. Invalid pet id.', 401) if correct_pet.nil?
			end
		end

		mount UserAPI
	    mount PetAPI
	    mount AuthAPI
	    mount PostAPI
	end
end