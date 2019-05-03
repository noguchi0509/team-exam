class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit
    unless @team.owner==current_user
      redirect_to dashboard_url, notice: 'チームの編集はオーナーのみ可能です'
    end
  end 

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: 'チーム作成に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: 'チーム更新に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'チーム削除に成功しました！'
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end
  
  def transfer_authority
    team = Team.find(params[:team_id])
    transfered_user = User.find(params[:transfered_user_id])
    
    if transfered_user == team.owner
      untransferelable_message ="既にこのチームのリーダーです"
      redirect_to team_url(params[:team_id]), notice: untransferelable_message
    else
      team.update!(owner:transfered_user)
      TransferAuthorityMailer.transfer_done_mail(transfered_user.email,team.name).deliver
      transfered_message = "リーダーを変更しました"
      redirect_to team_url(params[:team_id]), notice: transfered_message
    end
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end
  
end