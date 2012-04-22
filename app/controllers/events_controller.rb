class EventsController < ApplicationController
  before_filter :fetch_group 
  before_filter :authenticate_user!

  def upcoming 
    @events = current_user.upcoming_events #Event.find_user_events(current_user)

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  # GET /events
  # GET /events.json
  def browse
    period = get_period_from_params
    @events = Event.find_user_events_within_period(
      current_user,
      period[:start_date],
      period[:end_date]
    ) 

    respond_to do |format|
      format.html { render 'browse', :locals => { events: @events } }
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = @group.events.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to [@group, @event], notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
  
  private
  def get_period_from_params
    period = Hash.new

    if start_date_present?
      period[:start_date] = Time.new(
        params[:year_start], 
        params[:month_start], 
        params[:day_start]
      )
    end

    if end_date_present?
      period[:end_date] = Time.new(
        params[:year_end],
        params[:month_end],
        params[:day_end]
      )
    end

    period
  end

  def start_date_present?
    !params[:year_start].nil? && !params[:month_start].nil? && !params[:day_start].nil?
  end

  def end_date_present?
    !params[:year_end].nil? && !params[:month_end].nil? && !params[:day_end].nil?
  end
end
