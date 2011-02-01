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
  describe "#content" do
    it "returns the playload of a node" do
      @hh[:foo] << 1
      @hh[:foo] << 2
      @hh[:foo].content.should == [1,2]
    end
  end
  describe "#childrens_content" do
    it "aggregates the payload of just the subnodes" do
      @hh[:foo][:bar] << 2
      @hh[:foo][:baz] << 3
      @hh[:foo].childrens_content.should == [2,3]
    end
    describe "when true given as parameter" do
      it "aggregates the payload of the node and the subnodes" do
        @hh[:foo] << 1
        @hh[:foo][:bar] << 2
        @hh[:foo][:baz] << 3
        @hh[:foo].childrens_content(true).should == [1,2,3]
      end
    end
  end
  describe "#parents_content" do
    it "aggregates the payload of all parents" do
      @hh[:foo] << 1
      @hh[:foo][:bar] << 2
      @hh[:foo][:bar][:baz].parents_content(true).sort.should == [1,2]
    end
    describe "when true given as parameter" do
      it "aggregates the payload of all parents inlcuding the current node" do
        @hh[:foo] << 1
        @hh[:foo][:bar] << 2
        @hh[:foo][:bar].parents_content(true).sort.should == [1,2]
      end
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
    it "works with just a slash" do
      @hh << 1
      @hh[:foo] << 2
      @hh.path('/').content.should == [1]
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
