#!/usr/bin/ruby
require 'cgi'
require 'find'

BASEDIR = "/home/gtc/repos/tm4win"

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
  f.gsub!(/‘/, "&lsquo;")
  f.gsub!(/’/, "&rsquo;")
  f.gsub!(/↵/, "&crarr;")
  f.gsub!(/—/, "&mdash;")
  f.gsub!(/↓/, "&darr;")
  f.gsub!(/↵/, "&crarr;")
  f.chomp
end

def verbose_rename (orig_name, new_name)
  File.rename(orig_name, new_name)
  puts orig_name + " --> " + new_name
end

Find.find(BASEDIR) do |f|
   # if you want to skip all dirs
   #next if File.directory? f
   orig_name = File.basename(f)
   clean_name = sanitize(File.basename(f))
   #Kernel.raise "Found illegal char in supposedly clean: " + clean_name if clean_name =~ /[^[:ascii:]]/
   dirname = File.dirname(f) + "/"
   verbose_rename(dirname + orig_name, dirname + clean_name) unless (orig_name === clean_name)
end

