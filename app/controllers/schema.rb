# Schema for the GraphQL API

ProfileType = GraphQL::ObjectType.define do
  name 'Profile'
  description 'The experience tree of a user'

  field :uuid, !types.ID
  # field :user_id, types.Integer
  field :projects, types[ProjectType]
  field :contributions, types[ContributionType]
end

ProjectType = GraphQL::ObjectType.define do
  name 'Project'
  description 'A contextual grouping of work experiences'

  field :uuid, !types.ID
  field :title, !types.String
  field :summary, types.String
  field :contributions, types[ContributionType]
  field :childProjects, types[ProjectType]
  field :parentProjects, types[ProjectType]
end

ContributionType = GraphQL::ObjectType.define do
  name 'Contribution'
  description 'A concrete work experience'

  field :uuid, !types.ID
  field :title, !types.String
  field :summary, types.String
  field :parentProjects, types[ProjectType]
end

AddProjectMutationType = GraphQL::InputObjectType.define do
  name 'AddProjectMutationType'
  description 'AddProject mutation'

  argument :profileId, !types.String do
    description 'profile uuid'
  end

  argument :title, !types.String do
    description 'Project title'
  end

  argument :parentProjectId, types.String do
    description 'Parent project uuid'
  end

end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root of this schema'

  field :profile do
    type ProfileType
    argument :id, !types.ID
    description 'Find a Profile by user ID'
    resolve ->(obj, args, ctx) { Profile.find(args['id']) }
  end
end

MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :addProject do
    type ProjectType

    argument :profileId, !types.ID
    argument :title, !types.String
    argument :parentProjectId, types.ID

    description 'Adds a project'

    resolve ->(t, args, c) {
      profile_id = args[:profileId]
      title = args[:title]
      parent_project_id = args[:parentProjectId]

      begin
        profile = Profile.find(profile_id)
      rescue Neo4j::ActiveNode::Labels::RecordNotFound
        return GraphQL::ExecutionError.new("Invalid profileId #{profile_id}")
      end

      project = Project.create(title: title)
      if parent_project_id
        project.parentProjects
      else
        project.profile = profile
      end

      project.save

      return project

    }

  end

  field :removeProject do
    type GraphQL::BOOLEAN_TYPE

    argument :projectId, !types.ID

    description 'Removes a project'

    resolve ->(t, args, c) {
      project_id = args['projectId']

      begin
        project = Project.find(project_id)
      rescue Neo4j::ActiveNode::Labels::RecordNotFound
        return GraphQL::ExecutionError.new("Invalid projectId #{profile_id}")
      end

      project.destroy

      return true

    }
  end
end


Schema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType

  object_from_id ->(id, _ctx) { decode_object(id) }
  id_from_object ->(obj, type, _ctx) { encode_object(obj, type) }
  resolve_type ->(object, _ctx) { Schema.types[type_name(object)] }
end

def type_name(object)
  object.class.name
end

def encode_object(object, type)
  GraphQL::Schema::UniqueWithinType.encode(
      type.name,
      object.id,
      separator: '---'
  )
end

def decode_object(id)
  type_name, object_id = GraphQL::Schema::UniqueWithinType.decode(
      id,
      separator: '---'
  )
  Object.const_get(type_name).find(object_id)
end