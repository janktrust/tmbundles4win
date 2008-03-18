#!/usr/bin/ruby
require 'cgi'
require 'find'
require 'fileutils'
include FileUtils::Verbose

TMREPO_DIR  = "/home/gtc/repos/svn_textmate"
TRANSIT_DIR = "/home/gtc/repos/tm4win_transit"
WINREPO_DIR = "/home/gtc/repos/tmbundles4win"

def sanitize(f)
  f.gsub!(/</, "&lt;")
  f.gsub!(/>/, "&gt;")
  f.gsub!(/\|/, "&#124;")
  f.gsub!(/:/, "&#58;")
  f.gsub!(/\*/, "&#42;")
  f.gsub!(/…/, "&hellip;")
  f.gsub!(/\"/, "&quot;")
  f.gsub!(/\?/, "&#63;")
  f.gsub!(/\\/, "&#92;")
  f.gsub!(/“/, "&ldquo;")
  f.gsub!(/”/, "&rdquo;")
  f.gsub!(/↵/, "&crarr;")
  f.gsub!(/—/, "&mdash;")
  f.gsub!(/↓/, "&darr;")
  f.gsub!(/↵/, "&crarr;")
  f.gsub!(/‘/, "&lsquo;")
  f.gsub!(/’/, "&rsquo;")
  f.chomp
end

def verbose_rename (orig_name, new_name)
  File.rename(orig_name, new_name)
  puts orig_name + " --> " + new_name
end

# Update TM repo
puts %x(svn up #{TMREPO_DIR + '/Bundles'})
puts `svn up #{TMREPO_DIR + '/Support'}`

# Delete old transit dirs
rm_rf(TRANSIT_DIR + '/Bundles')
rm_rf(TRANSIT_DIR + '/Support')

# Export to transit dir
puts `svn export #{TMREPO_DIR + '/Bundles'} #{TRANSIT_DIR}/Bundles`
puts `svn export #{TMREPO_DIR + '/Support'} #{TRANSIT_DIR}/Support`

# Sanitize the transit dir
Find.find(TRANSIT_DIR) do |f|
   # if you want to skip all dirs
   #next if File.directory? f
   orig_name = File.basename(f)
   clean_name = sanitize(File.basename(f))
   #Kernel.raise "Found illegal char in supposedly clean: " + clean_name if clean_name =~ /[^[:ascii:]]/
   dirname = File.dirname(f) + "/"
   verbose_rename(dirname + orig_name, dirname + clean_name) unless (orig_name === clean_name)
end

# Sync transit dir and tmbundles4win dir
puts `rsync --archive --exclude .svn --verbose #{TRANSIT_DIR}/ #{WINREPO_DIR}/trunk`

# Commit tmbundles4win
puts `svn add #{WINREPO_DIR}/trunk/* --force && svn ci #{WINREPO_DIR}/trunk -m "Sync"`

