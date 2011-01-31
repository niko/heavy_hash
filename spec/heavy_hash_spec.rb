require 'rspec'
require File.join(File.expand_path(File.dirname(__FILE__)), '../lib/heavy_hash')

describe HeavyHash do
  before(:each) do
    @hh = HeavyHash.new
  end
  describe "[] <<" do
    it "adds to the content" do
      @hh[:foo] << 1
      @hh[:foo].content.should == [1]
    end
    it "allows deep adding" do
      @hh[:foo][:bar] << 1
      @hh[:foo][:bar] << 2
      @hh[:foo][:bar].content.should == [1,2]
    end
  end
  describe "#leaves" do
    it "adds the content of the sub leaves" do
      @hh[:foo] << 1
      @hh[:foo][:bar] << 2
      @hh[:foo][:bar] << 3
      @hh[:foo].leaves.should == [1,2,3]
    end
  end
  describe "#content" do
    it "returns the playload of a node" do
      @hh[:foo] << 1
      @hh[:foo] << 2
      @hh[:foo].content.should == [1,2]
    end
  end
  describe "#leaves" do
    it "aggregates the playlod of the node and all subnodes" do
      @hh[:foo] << 1
      @hh[:foo][:bar] << 2
      @hh[:foo][:baz] << 3
      @hh[:foo].leaves.should == [1,2,3]
    end
  end
  describe "#path" do
    it "is a convience for deep retrieval" do
      @hh[:foo][:bar][:baz] << 1
      @hh[:foo][:bar][:baz] << 2
      @hh.path('/foo/bar/baz').content.should == [1,2]
    end
    it "is a convience for deep assignment" do
      @hh.path('/foo/bar/baz') << 1
      @hh.path('/foo/bar/baz') << 2
      @hh[:foo][:bar][:baz].content.should == [1,2]
    end
  end
  describe "#remove" do
    it "remove empty branches" do
      @hh[:foo][:bar][:baz] << 1
      @hh[:foo][:bar][:baz].remove 1
      @hh[:foo][:bar].should be_empty
    end
    it "should not delete non empty branches" do
      @hh[:foo][:bar] << 1
      @hh[:foo][:bar][:baz][:fu] << 1
      @hh[:foo][:bar][:baz][:fu].remove 1
      @hh[:foo][:bar].should_not be_empty
      @hh[:foo][:bar].content.should == [1]
    end
  end
  describe "#root?" do
    it "be true for the root node" do
      @hh.should be_root
    end
    it "be false for all others" do
      @hh[:foo].should_not be_root
      @hh[:foo][:bar].should_not be_root
    end
  end
  describe "#to_s" do
    it "gimme a string" do
      @hh[:foo] << 1
      @hh[:foo][:bar] << 2
      @hh[:foo][:bar] << 3
      @hh.to_s.should == '( []{:foo=>( [1]{:bar=>( [2, 3]{} )} )} )'
    end
  end
end
