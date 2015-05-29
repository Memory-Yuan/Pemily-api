class API < Grape::API
	# use Rack::JSONP
	version 'v1', using: :path
    format :json
    prefix :api

    helpers do
		def clean_params(params)
			ActionController::Parameters.new(params)
		end
	end

    resource :pets do
    	desc  "get pet list"
    	get do
    		# Pet.all.limit(params[:limit]) if params[:limit]
    		Pet.all
    	end

		desc "Return a pet."
		params do
			requires :id, type: Integer, desc: "Pet id."
		end
		route_param :id do
			get do
				Pet.find(params[:id])
			end
		end

		desc "Create a pet."
		post do
			safe_params = clean_params(params).require(:pet).permit(:name)
			pet = Pet.new(safe_params)
			if pet.save
				Pet.all
			else
				error!('failed', 422)
			end
		end

		desc "Update a pet."
		params do
			requires :id, type: String, desc: "pet id."
		end
		put ':id' do
			pet = Pet.find(params[:id])
			safe_params = clean_params(params).require(:pet).permit(:name)
			if pet.update(safe_params)
				Pet.all
			else
				error!('failed', 422)
			end
		end

		desc "Delete a pet."
		params do
			requires :id, type: String, desc: "pet id."
		end
		delete ':id' do
			pet = Pet.find(params[:id])
			if pet.destroy
				Pet.all
			else
				error!('failed', 422)
			end
		end
    end
end