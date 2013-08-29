class MicropostsController < ApplicationController
  # Restrict create and destroy actions to signed in users.
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # Creating this empty array is needed b/c the feed views expect this
      # object.
      @feed_items = []
      render 'static_pages/home'
    end  	
  end

  def destroy
    @micropost.destroy
    redirect_to root_url  
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    # This could be implemented like this:
    # @micropost = Micropost.find_by(id: params[:id])
    # redirect_to root_url unless current_user?(@micropost.user)
    #
    # However, it's better to do lookups through the association:
    # http://www.rubyfocus.biz/blog/2011/06/15/access_control_101_in_rails_and_the_citibank-hack.html
    def correct_user
      # find_by returns nil if there are no matching microposts whereas find
      # raises an exception.
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end    
end