ActiveAdmin.register TranslationJob do

  index do
    column :id
    column :source
    column :target
    column :from_lang
    column :to_lang
    default_actions
  end

end
