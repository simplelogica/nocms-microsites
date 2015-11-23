class CreateNoCmsMicrositesMicrositeTranslations < ActiveRecord::Migration
  def change
    create_table :no_cms_microsites_microsite_translations do |t|
      t.references :no_cms_microsites_microsite
      t.string :locale
      t.string :root_path

    end

  end
end
