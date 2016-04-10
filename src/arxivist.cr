require "./arxivist/*"

require "http/client"
require "xml"
require "logger"

LOG = Logger.new(STDOUT)
LOG.level = Logger::DEBUG

module Arxivist

  NAMESPACES = {"urlset" => "http://www.sitemaps.org/schemas/sitemap/0.9",
                "arxiv" =>  "http://arxiv.org/schemas/atom",
                "atom" => "http://www.w3.org/2005/Atom"}

    def self.node_to_text(nodes : XML::NodeSet) : Array(String?)
      return nodes.map { |node| node.text }
    end

    def self.parse_titles(xml) : Array(String?)
      doi = xml.xpath("//atom:entry/atom:title", namespaces: NAMESPACES) as XML::NodeSet
      LOG.debug("Found #{doi.size} titles")
      self.node_to_text(doi)
    end

    def self.parse_urls(xml) : Array(String?)
      links = xml.xpath("//atom:entry/atom:id", namespaces: NAMESPACES)  as XML::NodeSet
      LOG.debug("Found #{links.size} link")
      self.node_to_text(links)
    end

    def self.parse_authors(xml) : Array(Array(String?))
      result = [] of Array(String?)
      authors = xml.xpath("//atom:entry", namespaces: NAMESPACES)  as XML::NodeSet
      authors.each do |author|
        a = author.xpath("atom:author/atom:name", namespaces: NAMESPACES) as XML::NodeSet
        result.push(a.map{|x| x.text})
      end
      result
    end


  class SearchOptions

    getter max_results, title_terms

    setter max_results

    def initialize()
      @max_results = 10
      @title_terms = [] of String
      @author_terms = [] of String
    end

    {% for name in %w(title author) %}

    def add_{{name.id}}_term(term : String)
      @{{name.id}}_terms.push(term)
    end

    def add_{{name.id}}_terms(terms : Array(String))
      @{{name.id}}_terms.concat(terms)
    end

    {% end %}

    def url
      query_string = ""
      if !(@title_terms.empty? && @author_terms.empty?)
        if !@title_terms.empty?
          query_string += @title_terms.map{|term| "ti:#{term}" }.join("+AND+")
        end
        if !@author_terms.empty?
          query_string += @author_terms.map{|term| "au:#{term}" }.join("+AND+")
        end

      else
        query_string = "all"
      end
      return "http://export.arxiv.org/api/query?search_query=#{query_string}&max_results=#{@max_results}"
    end
  end

  class Paper

    getter title, link, authors

    def initialize(@title, @link, @authors)
    end

    def to_s
      return "title: #{@title}, link: #{@link}, authors: #{@authors.join(", ")}"
    end
  end

  def self.search(options : SearchOptions) : Array(Paper)
    query_url = options.url
    LOG.debug("Fetching #{query_url}")
    response = HTTP::Client.get query_url

    xml = XML.parse(response.body)
    titles = self.parse_titles(xml)
    links = self.parse_urls(xml)
    authors = self.parse_authors(xml)
    number_nodes = titles.size
    return (0...number_nodes).map do |n|
      Paper.new titles[n], links[n], authors[n]
    end
  end
end
