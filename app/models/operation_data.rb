class OperationData
  include Mongoid::Document
  include Mongoid::Timestamps
  field :relay_status, type: Array
  field :schedulers, type: Object
  field :I1, type: Float
  field :I2, type: Float
  field :I3, type: Float
  field :IN, type: Float
  field :U12, type: Float
  field :U23, type: Float
  field :U32, type: Float
  field :V1N, type: Float
  field :V2N, type: Float
  field :V3N, type: Float
  field :P1, type: Float
  field :P2, type: Float
  field :P3, type: Float
  field :Q1, type: Float
  field :Q2, type: Float
  field :Q3, type: Float
  field :FDP, type: Float	  
  field :FDPS, type: Float			
  field :EP, type: Float
  field :EQ, type: Float		
  field :ES, type: Float
  field :F, type: Float
  field :TIMESTAMP, type: Integer
  validates_presence_of :relay_status, :schedulers, :I1, :I2, :I3, :IN, :U12, :U23, :U32, :V1N, :V2N, :V3N, :P1, :P2, :P3, :Q1, :Q2, :Q3, :FDP, :FDPS, :EP, :EQ, :ES, :F, :TIMESTAMP
end
