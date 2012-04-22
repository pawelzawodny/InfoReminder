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
    @period = get_period_from_params
    @events = Event.find_user_events_within_period(
      current_user,
      @period[:start_date],
      @period[:end_date]
    ) 

    respond_to do |format|
      format.html { render 'browse', :locals => { events: @events } }
      format.js  
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

    if has_start_date?
      period[:start_date] = get_date_from_params "start"
    end

    if has_end_date?
      period[:end_date] = get_date_from_params "end"
    end

    period
  end

  def get_date_from_params(name)
    if has_date?(name)
      has_partial_date(name) ? get_date_from_parts(name) : get_date_from_single_param(name)
    else
      nil
    end
  end

  def get_date_from_single_param(name)
    Time.parse params["date_#{name}"]
  end

  def get_date_from_parts(name)
   Time.new(
        params["year_#{name}"],
        params["month_#{name}"],
        params["day_#{name}"]
      )
  end

  def has_partial_date(name)
    (!params["year_#{name}"].nil? && !params["month_#{name}"].nil? && !params["day_#{name}"].nil?) 
  end

  def has_single_date(name)
    !params["date_#{name}"].nil?
  end

  def has_date?(name)
    has_partial_date(name) || has_single_date(name)
  end

  def has_start_date?
    has_date? "start"
  end

  def has_end_date?
    has_date? "end"
  end
end
