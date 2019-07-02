class AddInternalNameToNoCmsMicrositesMicrosite < ActiveRecord::Migration
  def change
    add_column :no_cms_microsites_microsites, :internal_name, :string
  end
end
