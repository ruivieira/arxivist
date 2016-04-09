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


  class SearchOptions

    getter max_results, terms

    setter max_results

    def initialize()
      @max_results = 10
      @terms = [] of String
    end

    def add_term(term : String)
    end

    def add_terms(terms : Array(String))
      @terms.concat(terms)
    end

    def url
      query_string = "all"
      if !@terms.empty?
        query_string += ":" + @terms.join("+AND+")
      end
      return "http://export.arxiv.org/api/query?search_query=#{query_string}&max_results=#{@max_results}"
    end
  end

  class Paper
    def initialize(@title, @link)
    end

    def to_s
      return "title: #{@title}, link: #{@link}"
    end
  end

  def self.search(options : SearchOptions) : Array(Paper)
    query_url = options.url
    LOG.debug("Fetching #{query_url}")
    response = HTTP::Client.get query_url

    xml = XML.parse(response.body)
    titles = self.parse_titles(xml)
    links = self.parse_urls(xml)
    number_nodes = titles.size
    (0...number_nodes).map do |n|
      p = Paper.new titles[n], links[n]
      puts(p.to_s)
      p
    end
  end
end
