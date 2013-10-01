require 'spec_helper'

describe "array stitcher" do
	describe "valid inputs" do
		describe "should return nil on two nils" do
			let!(:a) { ArrayStitcher.new(nil,nil) }
			specify { a.stitch.should be_nil }
		end
		describe "should return nil on two numbers" do
			let!(:a) { ArrayStitcher.new(1,2) }
			specify { a.stitch.should be_nil }
		end	
		describe "should return nil on two strings" do
			let!(:a) { ArrayStitcher.new('1','2') }
			specify { a.stitch.should be_nil }
		end	
		describe "should return nil on only one array" do
			let!(:a) { ArrayStitcher.new([1],'2') }
			let!(:b) { ArrayStitcher.new('1',[2]) }
			let!(:c) { ArrayStitcher.new([],nil) }
			specify { a.stitch.should be_nil }
			specify { b.stitch.should be_nil }
			specify { c.stitch.should be_nil }
		end		
	end

	describe "should stitch correctly simple arrays" do
		let!(:z) { ArrayStitcher.new([],[]) }
		let!(:a) { ArrayStitcher.new([1],[2]) }
		let!(:b) { ArrayStitcher.new([2],[1]) }
		let!(:c) { ArrayStitcher.new([1],[1]) }
		let!(:d) { ArrayStitcher.new([],[1]) }
		let!(:e) { ArrayStitcher.new([1],[]) }		
		specify { a.stitch.should == [1,2] }
		specify { b.stitch.should == [2,1] }
		specify { c.stitch.should == [1,1] }
		specify { d.stitch.should == [1] }
		specify { e.stitch.should == [1] }
		specify { z.stitch.should == [] }
	end	
	describe "should stitch correctly" do
		let!(:a) { ArrayStitcher.new([1,2,3],[10]) }
		let!(:b) { ArrayStitcher.new([1,2,3],[4,5,6]) }
		let!(:c) { ArrayStitcher.new([1,2],[1,2,3,4,5,6]) }
		let!(:d) { ArrayStitcher.new([1,2,3,4],['assaf']) }
		specify { a.stitch.should == [1,10,2,3] }
		specify { b.stitch.should == [1,4,2,5,3,6] }
		specify { c.stitch.should == [1,1,2,2,3,4,5,6] }
		specify { d.stitch.should == [1,'assaf',2,3,4] }
	end	
end


