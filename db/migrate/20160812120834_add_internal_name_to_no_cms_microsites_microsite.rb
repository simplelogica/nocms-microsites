active_record_migration_class =
  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[Rails::VERSION::STRING[0..2].to_f]
  else
    ActiveRecord::Migration
  end

class AddInternalNameToNoCmsMicrositesMicrosite < active_record_migration_class
  def change
    add_column :no_cms_microsites_microsites, :internal_name, :string
  end
end
