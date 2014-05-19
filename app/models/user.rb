class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Devisable
  include Sluggable
  include Avatarable

  has_many :streams
  has_many :bets

  slug_field :username
  validates :username, format: { with: /\A[\w\-]([\w\s\-](?<!\s(?<=\s\s))){0,15}(?<!\s)\z/,
                                 message: "must be 1-16 characters, can only include letters, numbers, -, _, and space, cannot start or end with space and a space cannot follow another space." }

  def to_s
    username
  end
end
