class Lead < Podio::Item
  APP_ID = 573839
  SPACE_ID = 153322
  
  # Find all items in the Leads app
  def self.all
    collection = self.find_all(APP_ID)
    collection[:all]
  end
  
  # Find valid lead contacts in the space
  def self.space_contacts
    Podio::Contact.find_all_for_space(SPACE_ID, :order => 'contact', :limit => 12, :contact_type => 'space,connection', :exclude_self => false)
  end
  
  # Find valid sales contacts in the space
  def self.users
    Podio::Contact.find_all_for_space(SPACE_ID, :order => 'contact', :limit => 12, :contact_type => 'user', :exclude_self => false)
  end
  
  # Find valid statuses
  def self.statuses
    app = Podio::Application.find(APP_ID)
    field = app.fields.find { |field| field['external_id'] == 'status' }
    field['config']['settings']['allowed_values']
  end
  
  def self.create_from_params(params)
    fields = {
      'company-or-organisation' => params[:organization],
      'contacts' => params[:lead_contact].to_i,
      'sales-contact' => params[:sales_contact].to_i,
      'potential-revenue' => { :value => params['potential_revenue'], :currency => 'USD' },
      'probability-of-sale' => params[:probability].to_i,
      'status' => params[:status],
      'next-follow-up' => DateTime.new(params['followup_at(1i)'].to_i, params['followup_at(2i)'].to_i, params['followup_at(3i)'].to_i).to_s(:db)
    }
    # raise fields.inspect
    self.create(APP_ID, { :fields => fields })
  end
  
  #
  # Map the field values return by the Podio API to simple getters
  #
  
  def organization
    field_values_by_external_id('company-or-organisation', :simple => true)
  end
  
  def lead_contact
    field_values_by_external_id('contacts', :simple => true).try(:[], 'name')
  end
  
  def sales_contact
    field_values_by_external_id('sales-contact', :simple => true).try(:[], 'name')
  end
  
  def potential_revenue
    field_values_by_external_id('potential-revenue').try(:first)
  end
  
  def probability
    field_values_by_external_id('probability-of-sale', :simple => true)
  end

  def status
    field_values_by_external_id('status', :simple => true)
  end
  
  def followup_at
    field_values_by_external_id('next-follow-up').try(:first).try(:[], 'start')
  end
  
  protected
  
    def field_values_by_external_id(external_id, options = {})
      if self.fields.present?
        values = self.fields.find { |field| field['external_id'] == external_id }['values']
        if options[:simple]
          values.first['value']
        else
          values
        end
      else
        nil
      end
    end
  
end