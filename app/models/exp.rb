class Exp
  include Neo4j::ActiveNode

  property :title, type: String
  property :summary, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  has_many :out, :parentProject, type: :BELONGS_TO_PROJECT, model_class: :Project
end