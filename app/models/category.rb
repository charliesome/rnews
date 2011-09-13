class Category < ActiveRecord::Base
  attr_accessible :name, :user_id
  
  belongs_to :user
  has_many :stories
  
  validates :name, :length => { :in => 2..64 },
    :format => { :with => /\A[a-z0-9_]*\z/, :message => 'may only contain lowercase alphanumeric characters and underscores' },
    :uniqueness => true
  validates :user_id, :presence => true
  
  def to_param
    name
  end

  VIEWS = %w(popular active newest)
  def self.popular
    []
    #TODO
    #joins(:favorites).group("categories.id").order("COUNT(favorites.id) DESC")
  end
  scope :active, joins(:stories).where("stories.created_at > ?", Time.now - 2.days).group("categories.id").order("COUNT(stories.id) DESC")
  scope :newest, order("created_at DESC")
    
  def views; %w(top latest); end  
  def top
    stories.order("(points - 1)/pow((unix_timestamp() - unix_timestamp(created_at))/3600 + 1, 1.5) desc")
  end
  def latest
    stories.order("created_at DESC")
  end
end