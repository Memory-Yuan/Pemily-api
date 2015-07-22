module V1
	class UserAPI < Base

	    resource :users do
	    	desc "Register account"
			params do
				requires :user, type: Hash do
					requires :email, type: String, desc: "Email address"
					requires :password, type: String, desc: "Password"
					requires :password_confirmation, type: String, desc: "password confirmation"
				end
			end
			post :register do
				user_params = clean_params(params).require(:user).permit(
					:email,
					:password,
					:password_confirmation)
				user = User.new(user_params)
				error!('register failed', 500) unless user.save
			end
	    	
	    	desc "Get User data"
			get :user_data do
				authenticate!
				user_json = @current_user.as_json(methods: [:avatar_url])
			end

			desc "upload user avatar"
	    	params do
				requires :avatar, type: Rack::Multipart::UploadedFile, desc: "image file."
			end
	    	post :upload_avatar do
	    		authenticate!
				@current_user.avatar = params[:avatar][:tempfile]
				error!('upload failed', 500) unless @current_user.save
	    	end
		end
	end
end