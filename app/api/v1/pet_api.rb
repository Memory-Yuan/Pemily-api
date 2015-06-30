module V1
	class PetAPI < Base

		before do
			authenticate!
		end

		resource :mypets do
			desc "Get user'pet list"
	    	get do
	    		@current_user.pets
	    	end

			desc "Return a pet of user"
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
			end
			get ':pet_id' do
				pet = @current_user.pets.find(params[:pet_id])
				if pet.nil?
					error!('Invalid pet id.', 404)
				else pet end
			end

			desc "Create a pet."
			params do
				requires :pet, type: Hash do
					requires :name, type: String, desc: "Pet's name."
				end
			end
			post do
				pet_params = clean_params(params).require(:pet).permit(:name)
				pet = @current_user.pets.build(pet_params)
				error!('create pet failed', 500) unless pet.save
			end

			desc "Update a pet."
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
				requires :pet, type: Hash do
					requires :name, type: String, desc: "Pet's name."
				end
			end
			put ':pet_id' do
				correct_pet!
				pet_params = clean_params(params).require(:pet).permit(:name)
				error!('update pet failed', 500) unless @correct_pet.update(pet_params)
			end

			desc "Delete a pet."
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
			end
			delete ':pet_id' do
				correct_pet!
				error!('delete pet failed', 500) unless @correct_pet.destroy
			end
		end

	    resource :pets do
			desc  "Get pet list"
			get do
				Pet.all
			end

			desc "Get my followed pet list"
			get :myfollowed do
				@current_user.followed_pets
			end

			desc "Return a pet."
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
			end
			get ':pet_id' do
				pet = Pet.includes(:followers).find(params[:pet_id])
				error!('Invalid pet id.', 404) if pet.nil?
				pet_json = pet.as_json
				pet_json["followers_count"] = pet.followers.size
				pet_json["is_followed"] = pet.followers.where(user_pet_follow_ships: {user_id: @current_user.id}).exists?
				pet_json
			end

			desc "follow a pet"
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
			end
			post ':pet_id/follow' do
				pet = @current_user.pets.find_by(id: params[:pet_id])
				error!("can't follow the pet of yours", 403) unless pet.nil?
				follow_ship = @current_user.user_pet_follow_ships.build(pet_id: params[:pet_id])
				error!('follow failed', 500) unless follow_ship.save
			end

			desc "unfollow a pet"
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
			end
			delete ':pet_id/unfollow' do
				follow_ship = @current_user.user_pet_follow_ships.find_by(pet_id: params[:pet_id])
				error!('unfollow failed', 500) unless (follow_ship and follow_ship.destroy)
			end
	    end
	end
end