class Service < ConstantRecord::Base
  columns :name, :symbol, :short
  data [ 'Microsoft Translator', :microsoft, 'MS'     ],
       [ 'Google Translate',     :google,    'Google' ]

  class NotFound < StandardError
  end

end
