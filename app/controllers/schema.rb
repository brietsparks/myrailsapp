# Schema for the GraphQL API

ProfileType = GraphQL::ObjectType.define do
  name 'Profile'
  description 'The experience tree of a user'
  interfaces [GraphQL::Relay::Node.interface]

  field :uuid, !types.ID

  field :projects, types[ProjectType]

  # connection :projects, ProjectType.connection_type do
  #   argument :since, types.String
  #
  #   # Return an Array or ActiveRecord::Relation
  #   resolve ->(profile, args, ctx) {
  #     profile.projects.all
  #   }
  # end

  # connection :projects, FetchProjects
end

FetchProjects = GraphQL::Field.define do
  description 'Fetches projects'
  type ProjectType.connection_type

  resolve -> (profile, _args, _ctx) {
    profile.projects.all
  }
end

ProjectType = GraphQL::ObjectType.define do
  name 'Project'
  description 'A contextual grouping of work experiences'
  interfaces [GraphQL::Relay::Node.interface]

  field :uuid, !types.ID
  field :title, !types.String
  field :summary, types.String
  field :contributions, types[ContributionType]
  field :childProjects, types[ProjectType]
  # connection :childProjects, ProjectType.connection_type, property: :childProjects
  field :parentProjects, types[ProjectType]
  # connection :parentProjects, ProjectType.connection_type, property: :parentProjects
end

ContributionType = GraphQL::ObjectType.define do
  name 'Contribution'
  description 'A concrete work experience'
  interfaces [GraphQL::Relay::Node.interface]

  field :uuid, !types.ID
  field :title, !types.String
  field :summary, types.String
  field :parentProjects, types[ProjectType]
  # connection :parentProjects, ProjectType.connection_type, property: :parentProjects
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

Schema = GraphQL::Schema.define do
  query QueryType

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
