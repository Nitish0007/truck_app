class ApplicationController < ActionController::Base
	skip_forgery_protection if: -> { request.format.json? }
	respond_to :json
	before_action :validate_request_format
	before_action :authenticate_request!

	def authenticate_request!
		fetch_token_from_request
		if @token.nil?
			render json: { error: 'Unauthorized request' }, status: :unauthorized
			return
		else
			decoded = JwtToken.verify(@token)
			if decoded.nil? || (decoded.present? && decoded["id"].blank?) || (decoded.present? && decoded["id"].to_i != params[:user_id].to_i)
				return render json: { error: 'Invalid Token!' }, status: :unauthorized
			end
			@current_user = User.find_by(id: decoded["id"])
			unless @current_user.present?
				return render json: { error: "User not found" }, status: :unauthorized
			end
		end
	end
	
	def current_user
		@current_user
	end

	def admin_user?
		@current_user.admin?
	end

	def allow_admin_only
		if !admin_user?
			render json: { message: "This action is protected, you don't have permission to perform this action" }, status: :unauthorized
		end
	end

	private
	def validate_request_format
		return render json: { error: 'Invalid request format. Please use JSON format' }, status: :bad_request if !request.format.json?
	end

	def fetch_token_from_request
		auth_header = request.headers['Authorization']
		@token = nil
		if auth_header.present?
			@token = auth_header.split(" ").last
		end
	end

end
