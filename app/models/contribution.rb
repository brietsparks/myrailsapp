class Contribution
  include Neo4j::ActiveNode
  property :title, type: String
  property :summary, type: String
  property :skills, type: [Skill]
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
end