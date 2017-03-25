class Profile
  include Neo4j::ActiveNode

  property :userId, type: Integer
end