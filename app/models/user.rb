class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+\z/ }
    validates :name, presence: true
    validates :password, presence: true
    
end
