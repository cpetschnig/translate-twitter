ActiveAdmin.register TranslationJob do

  index do
    column :id
    column :source
    column :target
    column :from_lang
    column :to_lang
    column :active
    default_actions
  end

  action_item :only => :show do
    if translation_job.active && translation_job.target.present?
      link_to('Fetch, Translate and Tweet', fetch_translate_and_tweet_admin_translation_job_path,
              :method => :post, :class => "member_link")
    end
  end

  member_action :fetch_translate_and_tweet, :method => :post do
    translation_job = TranslationJob.find(params[:id])
    translation_job.fetch_translate_and_tweet
    redirect_to collection_path, :notice => "Translations were tweeted."
  end

  controller do
    def edit; end
  end
end
