class Project
  include Neo4j::ActiveNode
  property :title, type: String
  property :summary, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  has_many :out, :parentProjects, type: :BELONGS_TO_PROJECT, model_class: :Project

  has_one :out, :profile, type: :BELONGS_TO_PROFILE
  has_many :out, :childProjects, type: :HAS_CHILD_PROJECT, model_class: :Project
  has_many :out, :contributions, type: :HAS_CONTRIBUTION, model_class: :Contribution

  # has_many :out, :parentProjects, type: :BELONGS_TO_PARENT_PROJECT, model_class: :Project
end

