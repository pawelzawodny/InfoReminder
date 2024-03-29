class GroupsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :search ]
  # GET /groups
  # GET /groups.json
  def search
    @query = params[:query] || ""
    @page = params[:page] || 1
    @groups = Group.search_public(@query, page: @page)

    respond_to do |format|
      format.html # index.html.erb
      format.js 
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
        format.html { redirect_to manage_groups_url, notice: 'Group was successfully created.' }
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
        format.html { redirect_to manage_groups_url, notice: 'Group was successfully updated.' }
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
      format.html { redirect_to manage_groups_url }
      format.json { head :ok }
    end
  end

  def manage
    @groups = Group.find_user_groups_categorised_by_membership(current_user)
    respond_to do |format|
      format.html 
    end
  end
end
