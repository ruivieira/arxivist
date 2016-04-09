require "./spec_helper"

module Arxivist
  describe Arxivist do

    it "should return the correct number of max results" do
      options = SearchOptions.new
      options.max_results = 10

      nodes = search(options)
      nodes.each {|paper| puts(paper)}
      nodes.size.should eq(10)
    end

    it "should create valid search terms" do
      options = SearchOptions.new
      options.add_terms(["Monte", "Carlo"])

      nodes = search(options)
      nodes.each {|paper| puts(paper)}
      nodes.size.should eq(10)
    end

  end
end
