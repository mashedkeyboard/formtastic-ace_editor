require "formtastic/ace_editor/version"
require 'formtastic/inputs/text_input'

module Formtastic
  module Inputs
    class AceInput < TextInput
      def to_html
        input_wrapping do
          label_html << builder.text_area(method, input_html_options) <<
          (<<-HTML).html_safe
          <div id="#{dom_id}-container" class="ace_editor_container"><div id="#{dom_id}-editor"></div></div>
          HTML
          if use_css
            label_html <<(<<-CSS).html_safe
            <style type="text/css">
              ##{dom_id} { display: none; }
              ##{dom_id}-container {
                height: #{height};
                position: relative;
              }
              ##{dom_id}-editor {
                position: absolute;
                top: 0;
                bottom: 0;
                left: #{left};
                right: 0;
              }
            </style>
            CSS
          end
          if use_js
            label_html <<(<<-JS).html_safe
            <script type="text/javascript">
              (function() {
                var editor = ace.edit('#{dom_id}-editor');
                editor.setValue(document.getElementById('#{dom_id}').value);
                editor.getSession().setUseWorker(false);
                editor.setTheme('ace/theme/#{theme}');
                editor.getSession().setMode('ace/mode/#{mode}');
                editor.clearSelection();
                editor.getSession().setUseSoftTabs(true);
                editor.getSession().setTabSize(2);
                editor.getSession().on('change', function(e) {
                  document.getElementById('#{dom_id}').value = editor.getValue();
                });
              })();
            </script>
            JS
          end
        end
        label_html
      end

      def theme
        options[:theme] || 'solarized_light'
      end

      def mode
        options[:mode] || 'html'
      end

      def height
        options[:height] || '500px'
      end
    
      def left
        options[:left] || '0'
      end
     
      def use_js
        options[:use_js] || true
      end
    
      def use_css
        options[:use_css] || true
      end
    end
  end
end
