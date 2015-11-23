class CreateNoCmsMicrositesMicrosite < ActiveRecord::Migration
  def change
    create_table :no_cms_microsites_microsite do |t|
      t.string :title
      t.string :domain
      t.string :root_path

      t.timestamps
    end

  end
end
