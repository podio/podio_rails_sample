class Lead < Podio::Item
  APP_ID = 573839
  
  def self.all
    collection = self.find_all(APP_ID)
    collection[:all]
  end
  
  def organization
    field_values_by_external_id('company-or-organisation', :simple => true)
  end
  
  def lead_contact
    field_values_by_external_id('contacts', :simple => true)['name']
  end
  
  def sales_contact
    field_values_by_external_id('sales-contact', :simple => true)['name']
  end
  
  def potential_revenue
    field_values_by_external_id('potential-revenue').first
  end
  
  def probability
    field_values_by_external_id('probability-of-sale', :simple => true)
  end

  def status
    field_values_by_external_id('status', :simple => true)
  end
  
  def followup_at
    field_values_by_external_id('next-follow-up').first['start']
  end
  
  protected
  
    def field_values_by_external_id(external_id, options = {})
      values = self.fields.find { |field| field['external_id'] == external_id }['values']
      if options[:simple]
        values.first['value']
      else
        values
      end
    end
  
end