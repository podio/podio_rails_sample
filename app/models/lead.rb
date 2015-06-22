class Lead < Podio::Item
  APP_ID = 12695955
  SPACE_ID = 3631649

  # Find all items in the Leads app
  def self.all
    collection = self.find_all(APP_ID)
    collection[:all]
  end

  # Find valid lead contacts in the space
  def self.space_contacts
    Podio::Contact.find_all_for_space(SPACE_ID, :order => 'contact', :limit => 12, :contact_type => 'space,connection', :exclude_self => false) rescue []
  end

  # Find valid sales contacts in the space
  def self.users
    Podio::Contact.find_all_for_space(SPACE_ID, :order => 'contact', :limit => 12, :contact_type => 'user', :exclude_self => false) rescue []
  end

  # Find valid statuses
  def self.statuses
    app = Podio::Application.find(APP_ID)
    field = app.fields.find { |field| field['external_id'] == 'status2' }
    field['config']['settings']['options'].map { |option| [option['text'], option['id']] }
  end

  def self.create_from_params(params)
    # raise fields.inspect
    self.create(APP_ID, { :fields => fields_from_params(params) })
  end

  def self.update_from_params(id, params)
    self.update(id, { :fields => fields_from_params(params) })
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

  def potential_revenue_value
    field_values_by_external_id('potential-revenue').try(:first).try(:[], 'value').to_i
  end

  def potential_revenue_currency
    field_values_by_external_id('potential-revenue').try(:first).try(:[], 'currency')
  end

  def probability
    field_values_by_external_id('probability-of-sale', :simple => true)
  end

  def status_id
    field_values_by_external_id('status2', :simple => true).try(:[], 'id')
  end

  def status_text
    field_values_by_external_id('status2', :simple => true).try(:[], 'text')
  end

  def followup_at
    field_values_by_external_id('next-follow-up').try(:first).try(:[], 'start').try(:to_datetime)
  end

  protected

    def field_values_by_external_id(external_id, options = {})
      if self.fields.present?
        field = self.fields.find { |field| field['external_id'] == external_id }
        if field
          values = field['values']
          if options[:simple]
            values.first['value']
          else
            values
          end
        else
          nil
        end
      else
        nil
      end
    end

    def self.fields_from_params(params)
      {
        'company-or-organisation' => params[:organization],
        'contacts' => (params[:lead_contact].present? ? params[:lead_contact].to_i : nil),
        'sales-contact' => (params[:sales_contact].present? ? params[:sales_contact].to_i : nil),
        'potential-revenue' => { :value => params['potential_revenue_value'], :currency => params['potential_revenue_currency'] },
        'probability-of-sale' => params[:probability].to_i,
        'status2' => params[:status_id].to_i,
        'next-follow-up' => DateTime.new(params['followup_at(1i)'].to_i, params['followup_at(2i)'].to_i, params['followup_at(3i)'].to_i).to_s(:db)
      }.delete_if { |k, v| v.nil? }
    end

end
