class AuthenticationController < ApplicationController

    skip_before_action :authenticate, only: [:login]

    def login
        @user = User.find_by email: params[:email]
        if !@user
            render json: {error: 'user not found'}, status: :unauthorized
        else
            if !@user.authenticate params[:password]
                render json: {error: 'bad password'}, status: :unauthorized
            else
                payload = {
                    user_id: @user.id,
                }
                secret = Rails.application.secret_key_base
                token = JWT.encode(payload, secret)
                render json: {token: token, username: @user.username, userId: @user.id, avatar_url: @user.avatar_url}, status: :created
            end
        end
    end
end
