class LeadsController < ApplicationController
  
  def index
    @leads = Lead.all
  end
  
  def new
    @lead = Lead.new
    
    @lead_contacts = Lead.space_contacts
    @sales_contacts = Lead.users
    @statuses = Lead.statuses
  end
  
  def create
    Lead.create_from_params(params['lead'])
    redirect_to leads_path, :notice => 'Lead created'
  end
  
end