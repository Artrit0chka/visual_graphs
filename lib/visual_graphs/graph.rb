# frozen_string_literal: true

require 'json'

module VisualGraphs
  class Graph
    attr_accessor :adjacency_list
    attr_accessor :edges

    def initialize
      @adjacency_list = {}
      @edges = []
    end

    def self.load_from_json(path)
      graph = Graph.new
      file = File.open(path)
      temp = JSON.load(file)
      temp.each do |k, v|
        temp_k = k.to_i
        graph.adjacency_list[temp_k] = v
        v.each { |adj_vertex|  graph.edges << [temp_k, adj_vertex] }
      end
      file.close
      graph
    end


    def self.adjacency_list_init(list)
      graph = Graph.new
      list.each do |pair|
        graph.adjacency_list.store(pair[0], pair[1])
        pair[1].each {|vertex| graph.edges << [pair[0], vertex] }
      end
      graph
    end

    def vertices
      @adjacency_list.keys
    end


    def insert_vertex(vertex)
      unless @adjacency_list.keys.include? vertex
        @adjacency_list[vertex] = []
        return true
      end
      false
    end

    # edge is array [1,2] , where 1 and 2 are vertex
    # also will insert vertexes unless they are not in adjecency_list
    def insert_edge(edge)
      unless @edges.include? edge
        insert_vertex(edge[0])
        insert_vertex(edge[1])
        @adjacency_list[edge[0]] << edge[1]
        @edges << edge
        return true
      end
      false
    end

    def output_to_standard_stream
      @adjacency_list.each do |vertex, adjacency_list|
        puts "#{vertex} : #{adjacency_list}"
      end
    end

    def correct_path?(path)
      path.is_a? String and path.end_with? '.json'
    end

    # will create json file and dump graph to it
    # throws No such file or directory error
    def dump_to_json(path)
      raise InvalidJSONFileNameError unless correct_path? path

      File.open(path, 'w') { |f| f.write(@adjacency_list.to_json) }
    end

    def ==(other_object)
        if not (self.vertices.sort == other_object.vertices.sort)
          return false
        end

        if not (self.edges.sort == other_object.edges.sort)
          return false
        end
        true
    end

    def ===(other_object)
      self == other_object
    end

    def eql?(other_object)
      if other_object.is_a? self.class
        if not (self.vertices.sort.eql? other_object.vertices.sort)
          return false
        end

        if not (self.edges.sort.eql? other_object.edges.sort)
          return false
        end
        return true
      end
      false
    end

  end
end