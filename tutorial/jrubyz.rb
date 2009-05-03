require "java"
require "lib/js.jar"
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
    JSProxy.new(context, scope, this).instance_exec(*(args.map {|x| JSProxy.new(context, scope, x)}), &@block)
  end
end

class JSProxy
  def self.new(context, scope, obj)
    ret = super
    if ret.obj.is_a?(Array)
      ret.obj
    else
      ret
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

  def convert(obj)
    java = obj.respond_to?(:java_class)
    if java && !undefined?(obj) && obj.has("length", @scope)
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
    end
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
    args = args.map {|arg| JSProxy.new(context, scope, arg)}
    RubyProxy.new(@object.new(*args))
  end
end

class RubyMethod
  include org.mozilla.javascript.Function
  
  def initialize(obj) @object = obj end
  
  def implements?(obj, interface)
    obj.class.ancestors.any? do |klass| 
      klass.respond_to?(:java_class) && klass.java_class == interface.java_class
    end  
  end
  
  def get(*args)
    p @object
    p args
  end
  
  def call(context, scope, this, args)
    args = args.to_a
    if implements?(args.last, org.mozilla.javascript.Function)
      function = JSFunction.new(context, scope, this, args.pop)
      JSProxy.new(context, scope, @object.call(*args, &function))
    else
      JSProxy.new(context, scope, @object.call(*args))
    end
  end
end

class RubyScope < RubyModule
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
  johnson = Johnson.new(context, scope)
  johnson.put("Ruby", RubyScope.new)
  johnson.put("Johnson", johnson)
  johnson.put("quit", Kernel.method(:exit))
  johnson.put("PLUGIN_PREFIX", root)
  johnson.put("print", Kernel.method(:puts))
  johnson.load("#{root}/lib/env.rhino.js")
  johnson.eval("window.location = '#{root}/tutorial/tabs.html'")
  johnson.load("#{root}/lib/jquery-1.2.6.js")
  johnson.load("#{root}/tutorial/run_specs.js")
ensure
  Context.exit
end