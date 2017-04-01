class ForceCreateProfileUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Profile, :uuid, force: true
  end

  def down
    drop_constraint :Profile, :uuid
  end
end
