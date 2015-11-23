class CreateMicrositeTranslations < ActiveRecord::Migration
  def change
    create_table :microsite_translations do |t|
      t.belongs_to :microsite
      t.string :locale
      t.string :root_path

    end

  end
end
