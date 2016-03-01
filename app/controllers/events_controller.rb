class EventsController < ApplicationController
  before_filter :authenticate_user!
  layout 'application'

  def index
    @user = current_user
    @events = current_user.invites.accepted.map(&:event)
  end

  def show
    @user = current_user
    @users = User.all
    @event = Event.where(id: params[:id]).first
    @invite = Invite.new
    @lists = @event.product_lists
  end

  def new
    @user = current_user
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @user = current_user
    @event.user = current_user
    return redirect_to new_event_path, alert: t(:inappropriate_date_and_time_of_the_event) unless @event.save
    @event.invites.create(user: @user, state: Invite::ACCEPT)
    redirect_to event_path(@event.id)
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    return redirect_to event_path(@event) if @event.update(event_params)
    render 'edit'
  end

  def destroy
    @event = Event.where(id: params[:id]).first.destroy
    redirect_to events_path
  end

  def calculate
    @event = Event.where(id: params[:event_id]).first
    calculate_error = @event.unavailable_to_calculate
    return redirect_to :back, alert: calculate_error if calculate_error
    @users_debts = @event.debts_calculation
    @money_transactions = debts_transactions(@users_debts)
  end

  def event_report
    @event = Event.find(params[:event_id])
    @lists = @event.product_lists if @event.present?
  end

  private

  def debts_transactions(users)
    transactions = []
    while user_with_minimal_debt(users).debt.round(2) < 0
      payer = user_with_maximal_debt(users)
      recipient = user_with_minimal_debt(users)
      transactions << create_transaction(payer, recipient, recipient.debt.abs >= payer.debt)
    end
    transactions
  end

  def create_transaction(payer, recipient, payer_owes_less_than_recipient_needs)
    if payer_owes_less_than_recipient_needs
      transaction = "#{payer.name} #{t(:owes)} #{recipient.name} #{payer.debt.abs.round}"
      recipient.debt += payer.debt
      payer.debt = 0
    else
      transaction = "#{payer.name} #{t(:owes)} #{recipient.name} #{recipient.debt.abs.round}"
      payer.debt += recipient.debt
      recipient.debt = 0
    end
    transaction
  end

  def user_with_minimal_debt(users)
    users.min_by(&:debt)
  end

  def user_with_maximal_debt(users)
    users.max_by(&:debt)
  end

  def event_params
    params.require(:event).permit(:name, :date, :state)
  end
end
