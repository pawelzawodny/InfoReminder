class GroupsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.where(public: true).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # Action used to confirm that user wants to join this group
  def confirm_join 
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def join
    @group = Group.find(params[:id])

    if @group.add_member(current_user)
      @success = true
    end

    respond_to do |format|
      format.html { redirect_to @group }
    end
  end

  def leave
    @group = Group.find(params[:id]) 

    if (@group.can_leave? current_user)
      membership = @group.membership(current_user)
      membership.destroy
    end

    redirect_to manage_groups_path
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])
    @group.user_id = current_user.id
  
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :ok }
    end
  end

  def manage
    @groups = Group.find_user_groups_categorised_by_membership(current_user)
    #@groups = Group.where( user_id: current_user.id ).all
    respond_to do |format|
      format.html 
    end
  end
end
