require "java"
require "../lib/js.jar"
import org.mozilla.javascript.Context
import org.mozilla.javascript.Scriptable
import org.mozilla.javascript.ScriptableObject
import org.mozilla.javascript.Undefined

class RubyFunction
  include org.mozilla.javascript.Function
  
  def initialize(&blk)
    @block = blk
  end
  
  def call(context, scope, this, args)
    JSProxy.build(context, scope, this).instance_exec(*(args.map {|x| JSProxy.build(context, scope, x)}), &@block)
  end
end

class JSProxy
  def self.build(context, scope, object)
    if [String, Numeric, TrueClass, FalseClass].any? {|k| object.is_a?(k)}
      object
    elsif object.respond_to?(:java_object) && object.java_object.java_class == java.lang.String.java_class
      object.to_s
    else
      JSProxy.new(context, scope, object)
    end
  end
    
  attr_reader :obj
  def initialize(context, scope, obj)
    @context, @scope = context, scope
    @obj = convert(obj)
  end
  
  def [](key)
    @obj.get(key.to_s, @scope)
  end
  
  # def []=(key, value)
  #   @obj.put(key.to_s, @scope, to_js(wrap_ruby(value), @scope))
  # end

  def to_js(obj, scope)
    case obj
    when String                then java.lang.String.new(obj)
    when Numeric               then java.lang.Float.new(obj)
    when TrueClass, FalseClass then java.lang.Boolean.new(obj)
    else                            Context.toObject(obj, scope)
    end
  end

  def convert(obj)
    java = obj.respond_to?(:java_class)
    if java && !undefined?(obj) && obj.respond_to?(:has) && obj.has("length", @scope)
      @context.getElements(obj).to_a
    else
      obj
    end
  end
  
  def inspect
    @obj.inspect
  end
  
  private
  def undefined?(obj)
    obj.java_class == Undefined.java_class
  end
end

class JSFunction
  def initialize(context, scope, this, function)
    @context, @scope, @this, @function = context, scope, this, function
  end
  
  def to_proc
    proc do |*args|
      @function.call(@context, @scope, @this, args.map {|arg| RubyProxy.new(arg) }.to_java(java.lang.Object))
    end
  end
end

class RubyProxy
  include org.mozilla.javascript.Scriptable

  def self.build(object)
    if [String, Numeric, TrueClass, FalseClass].any? {|k| object.is_a?(k)}
      object
    else
      RubyProxy.new(object)
    end
  end

  def initialize(object)
    @object = object
  end
  
  def inspect
    @object.inspect
  end
  
  def get(name, scope)
    if @object.methods.include?(name.to_s)
      if @object.is_a?(Array) && name == "length"
        @object.length
      else
        RubyMethod.new(@object.method(name))
      end
    elsif name.is_a?(Numeric) && @object.respond_to?(:[])
      @object[name.to_i]
    elsif @object.respond_to(:[])
      @object[name]
    else
      @object.instance_variable_get("@#{name}")
    end
  end
  
  def has(name, scope)
    @object.methods.any? {|m| m.to_s == name}
  end
  
  def getDefaultValue(hint)
    if hint.java_object == java.lang.Number.java_class
      @object.is_a?(Numeric) ? @object : 0
    elsif hint.java_object == java.lang.String.java_class
      @object.is_a?(String) ? @object : ""
    elsif hint.java_object == java.lang.Boolean.java_class
      false
    end
  end
end

class RubyModule < RubyProxy  
  def get(name, scope)
    if name =~ /^[A-Z]/ && @object.const_defined?(name)
      value = @object.const_get(value)
      if    value.is_a?(Class)  then RubyClass.new(value)
      elsif value.is_a?(Module) then RubyModule.new(value)
      else                           RubyProxy.new(value)
      end
    elsif @object.methods.include?(name.to_s)
      RubyMethod.new(@object.method(name))
    end
  end  
end

class RubyClass < RubyModule
  include org.mozilla.javascript.Function
  
  def construct(context, scope, args)
    args = args.map {|arg| JSProxy.build(context, scope, arg)}
    RubyProxy.new(@object.new(*args))
  end
end

class RubyMethod
  include org.mozilla.javascript.Function
  
  def initialize(obj) 
    @object = obj
  end
  
  def implements?(obj, interface)
    obj.class.ancestors.any? do |klass| 
      klass.respond_to?(:java_class) && klass.java_class == interface.java_class
    end  
  end
  
  def get(*args)
    p @object
    p args
  end
  
  def wrap_js(arg, context, scope)
    if arg.respond_to?(:java_object)
      JSProxy.build(context, scope, arg)
    else
      arg
    end
  end
  
  def call(context, scope, this, args)
    args = args.to_a
    if implements?(args.last, org.mozilla.javascript.Function)
      function = JSFunction.new(context, scope, this, args.pop)
      RubyProxy.build(@object.call(*args, &function))
    else
      args.map! {|arg| wrap_js(arg, context, scope) }
      RubyProxy.build(@object.call(*args))
    end
  end
end

class RubyScope < RubyModule
  def self.new
    allocate.send(:initialize)
  end
  
  def initialize
    @object = Kernel
  end
  
  def get(name, scope)
    if name =~ /^[A-Z]/ && Object.const_defined?(name)
      value = Object.const_get(name)
      if    value.is_a?(Class)  then RubyClass.new(value)
      elsif value.is_a?(Module) then RubyModule.new(value)
      else                           RubyProxy.new(value)
      end
    elsif Kernel.methods.include?(name.to_s)
      RubyMethod.new(Kernel.method(name))
    end
  end    
end

class Johnson
  attr_reader :context, :scope
  
  def initialize(context, scope)
    @context, @scope = context, scope
  end

  def load(file)
    @context.evaluateString(@scope, File.read(file), file, 1, nil)
  end
  
  def put(name, value)
    value = if value.is_a?(Method)
      RubyMethod.new(value)
    elsif !value.is_a?(Scriptable)
      RubyProxy.new(value)
    else
      value
    end
    ScriptableObject.putProperty(@scope, name, value)
  end
  
  def get(name)
    ScriptableObject.getProperty(@scope, name)
  end
  
  def eval(string)
    @context.evaluateString(@scope, string, "<eval>", 1, nil)
  end
end

begin
  root    = "#{File.expand_path(File.dirname(__FILE__))}/.."
  context = Context.enter
  scope   = context.initStandardObjects
  johnson = $johnson = Johnson.new(context, scope)
  johnson.put("Ruby", RubyScope.new)
  johnson.put("Johnson", johnson)
  johnson.put("quit", Kernel.method(:exit))
  johnson.put("PLUGIN_PREFIX", root)
  johnson.put("print", Kernel.method(:puts))
  johnson.load("#{root}/lib/env.rhino.js")
  johnson.eval("window.location = '#{root}/tutorial/tabs.html'")
  require File.join(File.dirname(__FILE__), "app")
  johnson.load("#{root}/lib/jquery-1.2.6.js")
  johnson.load("#{root}/tutorial/run_specs.js")
ensure
  Context.exit
end

exit