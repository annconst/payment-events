class EventsController < ApplicationController
  before_filter :authenticate_user!
  layout 'application'

  def index
    @user = current_user
    @events = current_user.events + current_user.invites.where(state: 1).map{|x| x.event}
  end

  def show
    @user = current_user
    @users = User.all
    @event = Event.find(params[:id])
    @invite = Invite.new
    @lists = @event.product_lists
  end

  def new
    @user = current_user
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.save!
    @event.users << current_user
    redirect_to events_path
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if event_params.present?
      @event.update(event_params)
    end
      redirect_to events_path
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  def calculate
    @event = Event.find(params[:event_id])
    @users_hash = Hash.new(0)
    (@event.invites.where(state: 1).map{|invite| invite.user_id} << @event.users.first.id).each do |id|
      @users_hash[id] = 0
    end
    params[:product_list].each do |id, value|
      product_list = ProductList.find(id)
      product_list.users.each do |user|
        @users_hash[user.id] = @users_hash[user.id] + value.to_f / product_list.users.count
      end
    end
  end

  def event_params
    params.require(:event).permit(:name, :date)
  end

end
