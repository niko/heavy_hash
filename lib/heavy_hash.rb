require 'forwardable'
require 'set'
require 'json'

class HeavyHash
  attr_reader :content, :hash
  extend Forwardable
  def_delegators :@hash, :[], :keys, :has_key?
  
  def initialize(parent=nil, key=nil)
    @content = []
    @key, @parent = key, parent
    @hash = Hash.new &proc{|hash,key| HeavyHash.new self, key }
  end
  
  def <<(value)
    materialize.content << value
  end
  
  def remove(value)
    content.delete value
    return if root?
    @parent.delete(@key) if empty?
  end
  
  def leaves
    content + hash.values.map(&:leaves).flatten
  end
  
  def empty?
    @content.empty? && keys.empty?
  end
  
  def path(path)
    path.scan(%r{[^/]+}).inject(self){|mem,meth| mem[meth.to_sym]}
  end
  
  def to_s
    "( #{content.inspect}#{hash.to_s} )"
  end
  
  protected
    def materialize
      return self if root?
      return @parent[@key] if @parent.has_key? @key
      
      @parent.materialize
      @parent.hash[@key] = self
    end
    
    def delete(key)
      @hash.delete key
      @parent.delete(@key) if empty? && @parent
    end
    
    def root?
      !@parent
    end

end
