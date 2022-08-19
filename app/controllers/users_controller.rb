class UsersController < ApplicationController

    before_action :authorize, only: [:show]
   
    def create
        newUser = User.create(permit_params)
        if newUser.valid?
            session[:user_id] = newUser.id 
            render json: newUser, status: :created
        else
            render json: { error: newUser.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        render json: User.find(session[:user_id])
    end


    private

    def authorize
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    end

    def permit_params
        params.permit(:username, :password, :password_confirmation)
    end
end
