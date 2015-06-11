module V1
	class PetAPI < Base

		before do
			authenticate!
		end

	    resource :pets do
	    	desc  "get pet list"
	    	get do
	    		# Pet.all.limit(params[:limit]) if params[:limit]
	    		@current_user.pets
	    	end

			desc "Return a pet."
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
			end
			get ':pet_id' do
				@current_user.pets.find(params[:pet_id])
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
				if pet.save
					{message: 'success'}
				else
					error!('create pet failed', 422)
				end
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
				if @correct_pet.update(pet_params)
					{message: 'success'}
				else
					error!('update pet failed', 422)
				end
			end

			desc "Delete a pet."
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
			end
			delete ':pet_id' do
				correct_pet!
				if @correct_pet.destroy
					{message: 'success'}
				else
					error!('delete pet failed', 422)
				end
			end
	    end
	end
end