module V1
	class PostAPI < Base

		before do
			authenticate!
		end

		helpers do
			def correct_post!
				current_pet!
				error!('Unauthorized. Invalid post id.', 401) if correct_post.nil?
			end

			def correct_post
				@correct_post = @current_pet.posts.find_by(id: params[:id])
			end
		end

	    resource :posts do

	    	desc  "get post list"
	    	get do
	    		Post.all.to_json(include: [:pet])
	    	end

	    	desc "Create talk type post"
			params do
				requires :post, type: Hash do
					requires :title, type: String, desc: "post title"
					requires :content, type: String, desc: "post content"
				end
			end
			post do
				current_pet!
				post_prarms = clean_params(params).require(:post).permit(:title, :content)
				post = @current_pet.posts.build(post_prarms)
				if post.save
					{message: 'success'}
				else
					error!('failed', 422)
				end
			end

			desc "Update a post."
			params do
				requires :id, type: Integer, desc: "Id of post."
				requires :post, type: Hash do
					requires :title, type: String, desc: "post title"
					requires :content, type: String, desc: "post content"
				end
			end
			put ':id' do
				correct_post!
				post_prarms = clean_params(params).require(:post).permit(:title, :content)
				if @correct_post.update(post_prarms)
					{message: 'success'}
				else
					error!('update pet failed', 422)
				end
			end

			desc "Delete a post"
			params do
				requires :id, type: Integer, desc: "Id of post."
			end
			delete ':id' do
				correct_post!
				if @correct_post.destroy
					{message: 'success'}
				else
					error!('delete post failed', 422)
				end
			end

		end
	end
end