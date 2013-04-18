# Holds the different translation services
class Service < ConstantRecord::Base
  columns :name, :symbol, :short
  data [ 'Microsoft Translator', :microsoft, 'MS'     ],
       [ 'Google Translate',     :google,    'Google' ]
end
