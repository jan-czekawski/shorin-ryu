class User
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :image, :image_cache 
  mount_uploader :image, ImageUploader
 
  # include ActiveModel::Validations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#, :confirmable
         
  has_many :events, dependent: :destroy

  # VALIDATIONS
  validates :email, format: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :login, presence: true, uniqueness: { case_sensitive: false } 

  ## Database authenticatable
  field :login,              type: String, default: ""
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :admin,              type: Boolean, default: false
  field :image,              type: String, default: ""
  

  
  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
end
