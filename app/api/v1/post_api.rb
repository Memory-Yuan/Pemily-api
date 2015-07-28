module V1
	class PostAPI < Base

		before do
			authenticate!
		end

		helpers do
			def correct_post!
				correct_pet!
				error!('Unauthorized. Invalid post id.', 401) if correct_post.nil?
			end

			def correct_post
				@correct_post = @correct_pet.posts.find_by(id: params[:post_id])
			end

			def correct_comment!
				correct_pet!
				error!('Unauthorized. Invalid comment id.', 401) if correct_comment.nil?
			end

			def correct_comment
				@correct_comment = @correct_pet.comments.find_by(id: params[:comment_id])
			end

			def target_post
				post = Post.find_by(id: params[:post_id])
				if post.nil?
					error!('Invalid post id.', 404)
				else post end
			end
		end

	    resource :posts do

	    	desc "Get all post list"
	    	get do
	    		page = if params[:page] then params[:page] else 1 end
	    		per_page = if params[:per_page] then params[:per_page] else 10 end
    			order = if params[:order] then params[:order] else 'updated_at' end + ' DESC'
	    		Post.includes(:pet, {comments: :pet})
	    			.paginate(page: page, per_page: per_page)
	    			.order(order)
	    			.as_json(include: [
	    				{pet: {methods: :avatar_url}},
	    				{comments: {include: {pet: {methods: :avatar_url}}}}
    				])
	    	end

	    	desc "Return a post."
			params do
				requires :post_id, type: Integer, desc: "Id of post."
			end
			get ':post_id' do
				post = Post.includes(:pet, {comments: :pet})
						   .find(params[:post_id])
						   .as_json(include: [
			    				{pet: {methods: :avatar_url}},
			    				{comments: {include: {pet: {methods: :avatar_url}}}}
		    				])
				if post.nil?
					error!('Invalid post id.', 404)
				else post end
			end

	    	desc "Get post of pet"
	    	params do
				requires :pet_id, type: Integer, desc: "Id of pet."
			end
	    	get 'of_pet/:pet_id' do
	    		pet = Pet.includes(posts: [:pet, {comments: :pet}]).find_by(id: params[:pet_id])
	    		if pet.nil?
	    			error!('Invalid pet id.', 404)
	    		else
	    			pet.posts.as_json(include: [
	    				{pet: {methods: :avatar_url}},
	    				{comments: {include: {pet: {methods: :avatar_url}}}}
    				])
	    		end
	    	end

	    	desc "Create post"
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
				requires :post, type: Hash do
					requires :title, type: String, desc: "post title"
					requires :content, type: String, desc: "post content"
				end
			end
			post do
				correct_pet!
				post_prarms = clean_params(params).require(:post).permit(:title, :content)
				post = @correct_pet.posts.build(post_prarms)
				error!('create post failed', 500) unless post.save
			end

			desc "Update a post."
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
				requires :post_id, type: Integer, desc: "Id of post."
				requires :post, type: Hash do
					requires :title, type: String, desc: "post title"
					requires :content, type: String, desc: "post content"
				end
			end
			put ':post_id' do
				correct_post!
				post_prarms = clean_params(params).require(:post).permit(:title, :content)
				error!('update pet failed', 500) unless @correct_post.update(post_prarms)
			end

			desc "Delete a post"
			params do
				requires :pet_id, type: Integer, desc: "Pet's id."
				requires :post_id, type: Integer, desc: "Id of post."
			end
			delete ':post_id' do
				correct_post!
				error!('delete post failed', 500) unless @correct_post.destroy
			end

			segment '/:post_id' do
				resource '/comments' do

					desc "Get comments"
					params do
						requires :post_id, type: Integer, desc: "Id of post."
					end
					get do
						post = target_post
						post.comments.as_json(include: {pet: {methods: :avatar_url}})
					end

					desc "Create comment"
					params do
						requires :pet_id, type: Integer, desc: "Pet's id."
						requires :post_id, type: Integer, desc: "Id of post."
						requires :comment, type: Hash do
							requires :content, type: String, desc: "comment content"
						end
					end
					post do
						correct_pet!
						post = target_post
						comment_prarms = clean_params(params).require(:comment).permit(:content)
						comment = post.comments.build(comment_prarms)
						comment.pet_id = params[:pet_id]
						error!('create comment failed', 500) unless comment.save
					end

					desc "Update a post."
					params do
						requires :pet_id, type: Integer, desc: "Pet's id."
						requires :post_id, type: Integer, desc: "Id of post."
						requires :comment_id, type: Integer, desc: "Id of comment"
						requires :comment, type: Hash do
							requires :content, type: String, desc: "comment content"
						end
					end
					put '/:comment_id' do
						correct_comment!
						comment_prarms = clean_params(params).require(:comment).permit(:content)
						error!('update comment failed', 500) unless @correct_comment.update(comment_prarms)
					end

					desc "Delete a comment"
					params do
						requires :pet_id, type: Integer, desc: "Pet's id."
						requires :post_id, type: Integer, desc: "Id of post."
						requires :comment_id, type: Integer, desc: "Id of comment"
					end
					delete '/:comment_id' do
						correct_comment!
						error!('delete comment failed', 500) unless @correct_comment.destroy
					end	
				end
			end
		end
	end
end