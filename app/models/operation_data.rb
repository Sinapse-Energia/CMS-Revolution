class OperationData
  include Mongoid::Document
  include Mongoid::Timestamps
  field :I1, type: String
  field :I2 , type: String
  field :I3 , type: Float
  field :IN , type: Float
  field :U12, type: Float
  field :U23, type: Float
  field :U32, type: Float
  field :V1N, type: Float
  field :V2N, type: Float
  field :V3N, type: Float
  field :P1 , type: Float
  field :P2 , type: Float
  field :P3 , type: Float
  field :Q1 , type: Float
  field :Q2 , type: Float
  field :Q3 , type: Float
  field :FDP1 , type: Float
  field :FDP2 , type: Float
  field :FDP3 , type: Float
  field :FDPS1, type: Float
  field :FDPS2, type: Float
  field :FDPS3, type: Float
  field :EP1, type: Float
  field :EP2, type: Float
  field :EP3, type: Float
  field :EQ1, type: Float
  field :EQ2, type: Float
  field :EQ3, type: Float
  field :ES1, type: Float
  field :ES2, type: Float
  field :ES3, type: Float
  field :F, type: Float
  field :TIMESTAMP, type: Time
end
