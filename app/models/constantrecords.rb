class TwitterAccountType < ConstantRecord::Base
  columns :name, :can_publish
  data [ 'Translation Source',  0 ],
       [ 'Translation Target', 1 ]
end

class Service < ConstantRecord::Base
  columns :name, :symbol
  data [ 'Microsoft Translator', :microsoft ],
       [ 'Google Translate',     :google    ]

  class NotFound < StandardError
  end

end
