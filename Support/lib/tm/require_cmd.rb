
require ENV["TM_SUPPORT_PATH"] + "/lib/escape"
require ENV["TM_SUPPORT_PATH"] + "/lib/exit_codes"

module TextMate
  class << self
    def require_cmd(cmd)
      unless File.executable?(cmd) or ENV['PATH'].split(':').any? { |dir| File.executable? File.join(dir, cmd) }
        TextMate::HTMLOutput.show(:title => "Can't find “#{cmd}” on PATH.", :sub_title => "") do |io|
          io << "<p>The current PATH is:</p>"
          io << "<blockquote>"
          ENV["PATH"].split(":").each do |p|
            io << htmlize(p + "\n")
          end
          io << "</blockquote>"
          io << "<p>Please add the directory containing “<code>#{cmd}</code>” to <code>PATH</code> in TextMate's Shell Variables preferences.</p>"
          io << "<p>Alternatively, TextMate can retrieve the <code>PATH</code> from Terminal install it in TextMate's preferences for you.</p>"
          io << "<h4 class=\"warn\">TextMate will be restarted.</h4>"
          io << "<p><button onclick=\"TextMate.system('#{(ENV["TM_SUPPORT_PATH"]+"/bin/set_tm_path.sh").gsub(" ", "\\\\\\\\ ")}', null)\">Set PATH</button></p>"
        end
        TextMate.exit_show_html
      end
    end
  end
end