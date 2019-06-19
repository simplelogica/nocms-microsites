active_record_migration_class =
  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[Rails::VERSION::STRING[0..2].to_f]
  else
    ActiveRecord::Migration
  end

class CreateNoCmsMicrositesMicrosite < active_record_migration_class
  def change
    create_table :no_cms_microsites_microsites do |t|
      t.string :title
      t.string :domain
      t.string :root_path

      t.timestamps
    end
  end
end
