Factory.define :classification_type do |f|
  f.sequence(:name){|n| "classification_type_#{n}"}
end
