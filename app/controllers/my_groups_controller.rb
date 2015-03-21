class MyGroupsController < ApplicationController

  include MyGroupsHelper

  before_action :logged_in,         only: [:index, :edit, :update, :destroy, :create, :ready_to_activate]
  before_action :can_create_groups, only: [:index, :edit, :update, :destroy, :create, :ready_to_activate]
  before_action :group_creates,     only: [:create]
  before_action :group_known,       only: [:edit, :update, :destroy, :ready_to_activate]
  before_action :user_matches,      only: [:edit, :update, :destroy, :ready_to_activate]
  before_action :group_not_active,  only: [:edit, :update, :destroy, :ready_to_activate]
  before_action :group_updates,     only: [:update]

  def index
  end

  def edit
  end

  def ready_to_activate
  end

  def update
    redirect_with_flash(FlashMessages::UPDATE_SUCCESS, edit_my_group_path(id: @group.id))
  end

  def destroy
    @group.destroy
    redirect_to my_groups_path
  end
  
  def create
    redirect_to edit_my_group_path(@group.id)
  end

  private

  def logged_in
    redirect_with_flash(FlashMessages::NOT_LOGGED_IN, root_url) if !logged_in?
  end

  def can_create_groups
    @user = current_user
    redirect_with_flash(FlashMessages::CANNOT_CREATE_GROUPS, root_url) if !@user.can_create_groups?
  end

  def group_creates
    @group = @user.groups_i_created.create(name: params[:group][:name])
    render_with_validation_flash(@group, action: :index) if !@group.valid?
  end

  def group_known
    @group = Group.find_by(id: params[:id])
    redirect_with_flash(FlashMessages::GROUP_UNKNOWN, my_groups_path) if @group.nil?
  end

  def user_matches
    redirect_with_flash(FlashMessages::USER_MISMATCH, my_groups_path) if @group.user_id != @user.id
  end

  def group_not_active
    redirect_with_flash(FlashMessages::GROUP_ACTIVE, my_groups_path) if @group.active?
  end

  def group_updates
    render_with_validation_flash(@group, action: :edit) if
      !@group.update_attributes(lifespan_rule:           params[:my_group][:lifespan_rule],
                                support_needed_rule:     params[:my_group][:support_needed_rule],
                                votespan_rule:           params[:my_group][:votespan_rule],
                                votes_needed_rule:       params[:my_group][:votes_needed_rule],
                                yeses_needed_rule:       params[:my_group][:yeses_needed_rule],
                                inactivity_timeout_rule: params[:my_group][:inactivity_timeout_rule])
  end

end
