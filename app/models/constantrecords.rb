class TwitterAccountType < ConstantRecord::Base
  columns :name, :can_publish
  data [ 'Translation Source',  0 ],
       [ 'Translation Target', 1 ]
end