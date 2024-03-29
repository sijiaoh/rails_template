class UsersController < ApplicationController
  skip_before_action :store_user_location!, only: %i[new]

  before_action :set_user, only: %i[show]
  before_action :set_omniauth_data, only: %i[new create]

  def show; end

  def new
    @user = User.new
    authorize @user
    skip_policy_scope
  end

  def create
    @user = User.build_with_social_profile(user_params, @omniauth_data)
    authorize @user
    skip_policy_scope

    if @user.save
      sign_in_and_redirect @user, event: :authentication
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = policy_scope(User).find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:terms_of_service)
  end

  def set_omniauth_data
    omniauth_data = session["devise.omniauth_data"]
    raise "devise.omniauth_data not found." unless omniauth_data

    @omniauth_data = omniauth_data
  end
end
