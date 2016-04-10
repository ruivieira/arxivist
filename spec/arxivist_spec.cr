require "./spec_helper"

module Arxivist
  describe Arxivist do

    it "should return the correct number of max results" do
      options = SearchOptions.new
      options.max_results = 10

      nodes = search(options)
      nodes.size.should eq(10)
    end

    it "should create valid search terms" do
      options = SearchOptions.new
      options.add_title_terms(["Monte", "Carlo"])

      nodes = search(options)
      nodes.size.should eq(10)
    end

    it "should fetch the correct authors" do
      options = SearchOptions.new
      authors = ["Owen", "Wilkinson", "Gillespie"]
      options.add_author_terms(authors)

      papers = search(options)

      papers.each do |paper|
        paper.authors.each {|author| authors.includes? author}
      end

      papers.each {|paper| puts(paper.to_s)}

    end

  end
end
