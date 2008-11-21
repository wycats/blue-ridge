class JavascriptSpecGenerator < Rails::Generator::NamedBase
  def manifest
    file_path_with_spec, file_path_without_spec = file_path_with_and_without_spec
    
    record do |m|
      m.directory 'test/javascript'
      m.directory 'test/javascript/fixtures'
      
      options = {:class_name_without_spec => class_name_without_spec}
      m.template 'javascript_spec.js.erb', "test/javascript/#{file_path_with_spec}.js", options
      m.template 'fixture.html.erb', "test/javascript/fixtures/#{file_path_without_spec}.html", options
    end
  end

  def file_path_with_and_without_spec
    if (file_path =~ /_spec$/i)
      [file_path, file_path.gsub(/_spec$/, "")]
    else
      [file_path + "_spec", file_path]
    end
  end
  
  def class_name_without_spec
    (class_name =~ /Spec$/) ? class_name.gsub(/Spec$/, "") : class_name
  end
end
