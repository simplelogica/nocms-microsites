active_record_migration_class =
  if Rails::VERSION::MAJOR >= 5
    ActiveRecord::Migration[Rails::VERSION::STRING[0..2].to_f]
  else
    ActiveRecord::Migration
  end

class CreateNoCmsMicrositesMicrositeTranslations < active_record_migration_class
  def change
    create_table :no_cms_microsites_microsite_translations do |t|
      t.references :no_cms_microsites_microsite
      t.string :locale
      t.string :root_path
    end
  end
end
