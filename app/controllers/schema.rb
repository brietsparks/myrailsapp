ProjectType = GraphQL::ObjectType.define do
  name 'Project'
  description 'A project'

  field :uuid, !types.ID
  field :title, !types.String
  field :summary, types.String
  field :subProjects, types[ProjectType]
  field :parentProjects, types[ProjectType]
end

# ProjectsType = GraphQL::ListType.define do
#
# end


QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root of this schema'

  field :project do
    type ProjectType
    argument :id, !types.ID
    description 'Find a Project by ID'
    resolve ->(obj, args, ctx) { Project.find(args['id']) }
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
end