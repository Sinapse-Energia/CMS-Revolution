class StaticData < ApplicationRecord
	validates_length_of :circuit_number, :maximum => 7 

end	
