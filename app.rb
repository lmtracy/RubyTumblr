#This blog is for people who enjoy travel

require 'sinatra'
require 'sinatra/activerecord'
require "sinatra/flash"
require "./models"

enable :sessions

set :database, "sqlite3:app.db"

#landing page
get "/" do
  if session[:user_id]
    erb :loggingin
  else
    erb :login
  end
end

get "/loggingin" do
  erb :loggingin
end

# # # displays sign in form
get "/login" do
  erb :login
end

# responds to sign in form
post "/login" do
  @user = User.find_by(username: params[:username])
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    redirect "/main"
  else
    # lets the user know that something is wrong
    flash[:warning] = "Your username or password is incorrect"

    # if user does not exist or password does not match then
    #   redirect the user to the sign in page
    redirect "/login"
  end
end

get "/signup" do
  erb :signup
end

post "/signup" do
  @user = User.create(
    username: params[:username],
    password: params[:password],
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
    birthday: params[:birthday]
  )
  # this line does the signing in
  session[:user_id] = @user.id

  # lets the user know they have signed up
  flash[:info] = "Thank you for signing up"

  # assuming this page exists
  redirect "/main"
end

get "/main" do
  @posts = Post.all.order("created_at DESC")
  erb :main
end
 
get "/post" do
  @posts = Post.all
  @user = User.first
  erb :post
end

post "/post" do
  # @user = current_user
  @post = Post.create(title: params[:title], content: params[:content])
  redirect "/main"
end

get "/users" do
  @users = User.all
  @post = Post.last
  User.all.map { |user| "USERNAME: #{user.username} PASSWORD:#{user.password}" }.join(", ")
  # erb :users
end

get "profile/:id" do
  @user = user.find(params[:user_id])
end

# when hitting this get path via a link
#   it would reset the session user_id and redirect
#   back to the homepage
get "/signout" do
  # this is the line that signs a user out
  session[:user_id] = nil

  # lets the user know they have signed out
  flash[:info] = "You have been signed out"
  
  redirect "/login"
end