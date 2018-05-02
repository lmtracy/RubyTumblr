require 'sinatra'
require 'sinatra/activerecord'
require "sinatra/flash"
require "./models"


enable :sessions

set :database, "sqlite3:app.db"

get "/" do
  if session[:user_id]
    erb :main
  else
    erb :main_loggedout
  end
end

# # # displays sign in form
get "/login" do
  erb :main
end

# responds to sign in form
post "/login" do
  @user = User.find_by(username: params[:username])


  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    redirect "/"
  else
    # lets the user know that something is wrong
    flash[:warning] = "Your username or password is incorrect"

    # if user does not exist or password does not match then
    #   redirect the user to the sign in page
    redirect "/main_loggedout"
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
  redirect "/"
end

get "/posts" do
  @posts = Post.all
  @user = User.first
end

get "posts/new" do
  erb :main
end

get "/users" do
  @users = User.all
  @post = Post.last
end



# when hitting this get path via a link
#   it would reset the session user_id and redirect
#   back to the homepage
get "/sign-out" do
  # this is the line that signs a user out
  session[:user_id] = nil

  # lets the user know they have signed out
  flash[:info] = "You have been signed out"
  
  redirect "/"
end