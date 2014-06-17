require "formtastic/ace_editor/version"
require 'formtastic/inputs/text_input'

module Formtastic
  module Inputs
    class AceInput < TextInput
      def to_html
        input_wrapping do
          label_html << builder.text_area(method, input_html_options) <<
          (<<-JS).html_safe
          <div id="#{dom_id}-container" class="ace_editor_container"><div id="#{dom_id}-editor"></div></div>
          <style type="text/css">
            ##{dom_id} { display: none; }
            ##{dom_id}-container {
              height: 200px;
              position: relative;
            }
            ##{dom_id}-editor {
              position: absolute;
              top: 0;
              bottom: 0;
              left: 0;
              right: 0;
            }
          </style>
          <script type="text/javascript">
            // make it easier to access the editor later on.
            window._ACE_EDITORS = window._ACE_EDITORS || {};
            (function() {
              var editor = ace.edit('#{dom_id}-editor');
              editor.setValue(document.getElementById('#{dom_id}').value);
              editor.getSession().setUseWorker(false);
              editor.setTheme('ace/theme/#{theme}');
              editor.getSession().setMode('ace/mode/#{mode}');
              editor.clearSelection();
              editor.getSession().on('change', function(e) {
                document.getElementById('#{dom_id}').value = editor.getValue();
              });
              
              // binti-specific
              editor.getSession().setTabSize(2);
              editor.getSession().setUseSoftTabs(true);
              _ACE_EDITORS['#{dom_id}'] = editor;
            })();
          </script>
          JS
        end
      end

      def theme
        options[:theme] || 'solarized_light'
      end

      def mode
        options[:mode] || 'html'
      end
    end
  end
end
