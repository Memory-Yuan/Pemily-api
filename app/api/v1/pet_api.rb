module V1
	class PetAPI < Base

	    resource :pets do
	    	desc  "get pet list"
	    	get do
	    		# Pet.all.limit(params[:limit]) if params[:limit]
	    		Pet.all
	    	end

			desc "Return a pet."
			params do
				requires :id, type: Integer, desc: "Pet's id."
			end
			get ':id' do
				Pet.find(params[:id])
			end

			desc "Create a pet."
			params do
				requires :pet, type: Hash do
					requires :name, type: String, desc: "Pet's name."
				end
			end
			post do
				pet_params = clean_params(params).require(:pet).permit(:name)
				pet = Pet.new(pet_params)
				if pet.save
					Pet.all
				else
					error!('create pet failed', 422)
				end
			end

			desc "Update a pet."
			params do
				requires :id, type: Integer, desc: "Pet's id."
				requires :pet, type: Hash do
					requires :name, type: String, desc: "Pet's name."
				end
			end
			put ':id' do
				pet = Pet.find(params[:id])
				pet_params = clean_params(params).require(:pet).permit(:name)
				if pet.update(pet_params)
					Pet.all
				else
					error!('update pet failed', 422)
				end
			end

			desc "Delete a pet."
			params do
				requires :id, type: Integer, desc: "Pet's id."
			end
			delete ':id' do
				pet = Pet.find(params[:id])
				if pet.destroy
					Pet.all
				else
					error!('delete pet failed', 422)
				end
			end
	    end
	end
end