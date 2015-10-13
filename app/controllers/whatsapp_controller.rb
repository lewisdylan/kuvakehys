class WhatsappController < ApplicationController
	skip_before_action :verify_authenticity_token

	def receive
		user = User.find_or_create_by(phone: params['phone_number'])

		if params.has_key?(:text)
			group = Group.find_by(email: params[:text])
			if !group.nil?
				user.group = group
				user.save!
				message = "You have been added to the group #{group.email}. You can now send your pictures to be added there."
			else
				message = "Sorry group #{params[:text]} does not exist."
			end

		else

			if !user.group.nil?
				user.group.photos.create(user: user, picture: params['image'])
				message = "Picture successfully added to group #{user.group.email}" 
			else
				message = "Please specify which group to send to"
			end
		end
		send_message(user.phone, message)
		render text: 'ok'
	end

	def send_message(phone, message)
	end
end
