class LeadsController < ApplicationController
  before_filter :load_collections, :only => [:new, :edit]

  def index
    @leads = Lead.all
  end

  def new
    @lead = Lead.new
  end

  def create
    Lead.create_from_params(params['lead'])
    redirect_to leads_path, :notice => 'Lead created'
  end

  def edit
    @lead = Lead.find_basic(params[:id])
  end

  def update
    Lead.update_from_params(params[:id], params['lead'])
    redirect_to leads_path, :notice => 'Lead updated'
  end

  def destroy
    Lead.delete(params[:id])
    redirect_to leads_path, :notice => 'Lead deleted'
  end

  protected

    def load_collections
      @lead_contacts = Lead.space_contacts
      @sales_contacts = Lead.users
      @statuses = Lead.statuses
    end

end
