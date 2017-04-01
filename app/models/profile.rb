class Profile
  include Neo4j::ActiveNode

  property :user_id, type: Integer

  has_many :out, :projects, type: :HAS_CHILD_PROJECT, model_class: :Project
  has_many :out, :contributions, type: :HAS_CONTRIBUTION, model_class: :Contribution
end