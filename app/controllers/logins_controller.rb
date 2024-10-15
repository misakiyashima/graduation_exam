class LoginsController < ApplicationController
  def new; 
    render 'sessions/new'
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to root_path
    else
      render :new
    end
  end
end
