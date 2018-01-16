class UsersController < ApplicationController
  def show
    @users = User.all
  end

  def new 
  end
  
  def create
    user = User.new
    user.name = params[:user][:name]
    user.username = params[:user][:username]
    user.password = params[:user][:password]
    if !User.find_by(username: user.username)
      user.save
      flash[:notice] = "Usuário #{user.username} criado com sucesso!"
    else
      flash[:notice] = "O nome de usuário #{user.username} já está em uso"
    end
    redirect_to :action => "new"
  end
  
end
