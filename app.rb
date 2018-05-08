#This blog is for people who enjoy travel

require 'sinatra'
require 'sinatra/activerecord'
require "sinatra/flash"
require "./models"

enable :sessions

# Setting up Heroku deployment
# set :database, "sqlite3:app.db"

configure :development do
  set :database, "sqlite3:app.db"
end

configure :production do
  set :database, ENV["DATABASE_URL"]
end

#landing page
get "/" do
  if session[:user_id]
    erb :loggingin
  else
    erb :login
  end
end

#loading page when returning user logs in
get "/loggingin" do
  @user = User.find(session[:user_id])

  erb :loggingin
end

# displays sign in form
get "/login" do
  erb :login
end

# responds to sign in form
post "/login" do
  @user = User.find_by(username: params[:username])
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    redirect "/loggingin"
  else
    # lets the user know that something is wrong
    flash[:warning] = "Your username or password is incorrect"

    # if user does not exist or password does not match then
    #   redirect the user to the sign in page
    redirect "/login"
  end
end

#for users to register for site
get "/signup" do
  erb :signup
end

post "/signup" do
  @user = User.create(
    username: params[:username],
    password: params[:password],
    userimage: params[:userimage],
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
    birthday: params[:birthday]
  )
  session[:user_id] = @user.id

  # flash[:info] = "Thank you for signing up"

  redirect "/main"
end

#main page that displays all posts by each user
get "/main" do
  @posts = Post.all.order("created_at DESC")
  @user = User.all
  erb :main
end
 
get "/post" do
  @posts = Post.all
  # @user = User.first
  @user = User.find(session[:user_id])

  erb :post
end

post "/post" do
  @post = Post.create(
    title: params[:title], 
    content: params[:content], 
    image: params[:image], 
    user_id: session[:user_id]
    )

  redirect "/main"
end

#delete posts
delete "/post/:id/delete" do
  @post = Post.find_by_id(params[:id])
  @post.delete
  redirect "/profile"
end

# This page isn't part of site, use to see list of existing users
get "/users" do
  User.all.map { |user| "USERNAME: #{user.username} PASSWORD:#{user.password}" }.join(", ")
end

get "/profile" do
  @user = User.find(session[:user_id])
  @posts = @user.posts.order("created_at DESC")
  erb :profile
end

# get "/profile/:id" do
#   @user = User.find(session[:user_id])
#   @posts = @user.posts.order("created_at DESC")
# end

get "/userprofile" do
  erb :userprofile
end

get "/userprofile/:id" do
  @user = User.find(params[:id])
  @posts = @user.posts.order("created_at DESC")
  erb :userprofile
end


get "/signout" do
  session[:user_id] = nil
  
  redirect "/login"
end

#delete account
get "/delete" do 
  erb :delete
end

delete "/delete" do
  @user = User.find(session[:user_id])
  @user.destroy
  redirect "/login"
end
