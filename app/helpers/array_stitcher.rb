class ArrayStitcher
	
	attr_reader :array1, :array2

	def initialize(a,b)
		@array1=a if a.class==Array
		@array2=b if b.class==Array
	end

	def stitch
		process unless invalid
	end

	private
	def invalid
		@array1.nil? || @array2.nil?
	end

	def process
		result=[]
		size=[@array1.size,@array2.size].max
		size.times do |position|
			result << @array1[position] unless @array1[position].nil?
			result << @array2[position] unless @array2[position].nil?
		end
		result
	end

end
