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
    @event.user = current_user
    @event.save!
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
    Product.update(params[:products].keys, params[:products].values)
    @event = Event.find(params[:event_id])
    @users_hash = {}
    @sum = 0
    @event.product_lists.each do |list|
      list.without_users? ? @sum = @sum + list.all_price : increase_users_sum(list)
    end
    @users_hash = @users_hash.map{ |l, v| { name:User.find(l).name, value: v } }
  end

  def event_report
    @event = Event.find(params[:event_id])
    if @event.present?
      @lists = @event.product_lists
    end
  end

  private

  def increase_users_sum(list)
    list.users.each do |user|
      @users_hash[user.id] = @users_hash[user.id].to_f + list.all_price/ list.users.count
    end
  end

  def event_params
    params.require(:event).permit(:name, :date, :state)
  end

end