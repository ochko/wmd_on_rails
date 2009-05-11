module WmdOnRails
  module EditorHelper
    def enable_wmd(user_params = {})
      default_params = {
        :output => 'Markdown'
      }
      params = default_params.merge(user_params)
      
      output = javascript_tag "wmd_options = #{params.to_json}"
      output += javascript_include_tag "wmd/wmd"
      output += stylesheet_link_tag "wmd"
      output
    end
    
    def enable_resizable_wmd(user_params = {})
      default_params = {
        :output => 'Markdown'
      }
      params = default_params.merge(user_params)
      
      output = javascript_tag "wmd_options = #{params.to_json}"
      output += javascript_include_tag "wmd/wmd"
      output += javascript_include_tag "wmd/textarearesizer"
      output += stylesheet_link_tag "wmd"
      output
    end
    
    def wmd_preview(params = {})
      id = params[:id] || 'wmd-preview'
      params = { :tag => :div, :class => '' }.merge(params)
      
      tag = params[:tag]
      html_class = params[:class].split(/\s+/).push('wmd-preview').join(" ")
      
      content_tag(tag, '', :class => html_class, :id => id)
    end

    def create_wmd(textarea_id, preview_id = nil)
      js = <<EOF
var textarea = document.getElementById(#{textarea_id.inspect});
EOF
      if preview_id
        js += <<EOF
var preview = document.getElementById(#{preview_id.inspect});
var panes = {input: textarea, preview: preview, output: null};
var previewManager = new Attacklab.wmd.previewManager(panes);
var editor = new Attacklab.wmd.editor(textarea, previewManager.refresh);
EOF
      else
        js += <<EOF
var editor = new Attacklab.wmd.editor(textarea);
EOF
      end

      javascript_tag js
    end
    
    def wmd_textarea(object, field, options = {})
      var = instance_variable_get("@#{object}")
      if var
        value = var.send(field.to_sym)
        value = value.nil? ? "" : value
      else
        value = ""
        klass = "#{object}".camelcase.constantize
        instance_variable_set("@#{object}", eval("#{klass}.new()"))
      end
      id = wmd_element_id(object, field)

      cols = options[:cols].nil? ? '' : "cols='"+options[:cols]+"'"
      rows = options[:rows].nil? ? '' : "rows='"+options[:rows]+"'"

      width = options[:width].nil? ? '100%' : options[:width]
      height = options[:height].nil? ? '100%' : options[:height]

      html_class = options[:class].nil? ? 'wmd-textarea' : options[:class]
      if options[:ajax]
        inputs = "<input type='hidden' id='#{id}_hidden' name='#{object}[#{field}]'>\n" <<
                 "<textarea id='#{id}' #{cols} #{rows} name='#{id}' class='#{html_class}'>#{value}</textarea>\n"
      else
        inputs = "<textarea id='#{id}' #{cols} #{rows} name='#{object}[#{field}]' class='#{html_class}'>#{value}</textarea>\n"
      end

      return inputs <<
        create_wmd(id)
    end
    
    def wmd_resizable_textarea(object, field, options ={})
      content = wmd_textarea(object, field, :class=>'resizable')
      return content <<
        javascript_tag("$(document).ready(function() {$('textarea.resizable:not(.processed)').TextAreaResizer();});")
    end
    
    def wmd_editor(object, field, options ={})
      content = wmd_resizable_textarea(object, field, options)
      return content << wmd_preview(:id => wmd_element_id(object, field))
    end
    
    def wmd_element_id(object, field)
      id = eval("@#{object}.id")
      "#{object}_#{id}_#{field}_wmd"
    end
    
  end
end
