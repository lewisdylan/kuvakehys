class User < ActiveRecord::Base
	belongs_to :group
	has_many :photos, dependent: :nullify
end
