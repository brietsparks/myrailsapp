class Skill
  include Neo4j::ActiveNode

  property :title, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  has_many :out, :contributions, type: :USED_FOR, model_class: :Contribution

end