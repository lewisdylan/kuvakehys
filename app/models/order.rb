class Order < ActiveRecord::Base
  belongs_to :group
  has_many :photos

  def complete!
    # TODO order the picutes
  end
end
