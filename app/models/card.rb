class Card < ActiveRecord::Base
  attr_accessible :first, :id, :img_url, :last, :name, :url
end
