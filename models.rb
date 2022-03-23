require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    validates :email,
        presence: true,
        length: { maximum: 300 },
        format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    validates :password,
        length: { in: 5..20 }
    has_many :blogs
end

class Coin < ActiveRecord::Base
    
end

class Count < ActiveRecord::Base
    
end

class Blog < ActiveRecord::Base
    belongs_to :user
    validates :body_text,
        length: { maximum: 300 }
end