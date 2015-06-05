module V1
	class AuthAPI < Base

	    resource :auth do

			desc "Creates and returns access_token if valid signin"
			params do
				requires :email, type: String, desc: "Email address"
				requires :password, type: String, desc: "Password"
			end
			post :signin do
				user = User.where(email: params[:email]).first

				if user && user.valid_password?(params[:password])
					key = ApiKey.create(user_id: user.id)
					{token: key.access_token}
				else
					error!('Unauthorized.', 401)
				end
			end

			desc "Returns pong if authenticated correctly"
			# params do
			# 	requires :token, type: String, desc: "Access token."
			# end
			get :ping do
				authenticate!
				{ message: "pong" }
			end

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
				error!('register failed', 422) unless user.save
			end

			desc "Get User data"
			get :user_data do
				authenticate!
				current_user
			end

		end
	end
end