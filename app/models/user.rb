class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :encrypt_password  

attr_accessor :password  
  validates_confirmation_of :password  
  validates_presence_of :password, :on => :create  
  validates_presence_of :email  
  validates_uniqueness_of :email

def encrypt_password  
    if password.present?  
      self.password_salt = BCrypt::Engine.generate_salt  
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)  
    end  
end



      def self.authenticate(email, password)
        user = self.find_by_email(email)

        if user
          expected_password = encrypt_password(password, user.password_salt)
          if user.hashed_password != expected_password
            user = nil
          end
        end
        user
      end

end
