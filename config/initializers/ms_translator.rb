def ms_app_id
  filename = Rails.root + "config/ms-translator.yml"
  yml_result = YAML::load(File.read(filename))
  yml_result['app_id']
end

Microsoft::Translator.set_app_id(ms_app_id)
