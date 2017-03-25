# Schema for the GraphQL API

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