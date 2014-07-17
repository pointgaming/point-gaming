class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Devisable
  include Sluggable
  include Avatarable

  has_many :streams

  slug_by :username
  validates :username, format: { with: /\A[\w\-]([\w\s\-](?<!\s(?<=\s\s))){2,15}(?<!\s)\z/,
                                 message: "must be 3-16 characters, can only include letters, numbers, -, _, and space, cannot start or end with space and a space cannot follow another space." }

  field :points, type: Integer, default: 50

  def to_s
    username
  end

  def publish_points
    Redis.new.publish("user.#{id}", JSON({ action: "points", points: points }))
  end
end
