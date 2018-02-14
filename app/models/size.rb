class Size
  include Mongoid::Document

  field :xs, type: Integer
  field :sml, type: Integer
  field :med, type: Integer
  field :lrg, type: Integer
  field :x_lrg, type: Integer
  field :xx_lrg, type: Integer
  embedded_in :item, :inverse_of => :item
end
