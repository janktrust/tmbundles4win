#!/usr/bin/ruby
require 'uri'
require 'find'
require 'fileutils'
include FileUtils::Verbose

TMREPO_DIR  = "/home/gtc/repos/svn_textmate"
TRANSIT_DIR = "/home/gtc/repos/tm4win_transit"
WINREPO_DIR = "/home/gtc/repos/tmbundles4win"
BADCHARS = /([<>\|:\*…\"\?\\“”↵—↓↵‘’])/

def sanitize(f)
	URI.escape(f, BADCHARS).chomp
end

def verbose_rename (orig_name, new_name)
  File.rename(orig_name, new_name)
  puts orig_name + " --> " + new_name
end

# Update TM repo
#puts %x(svn up #{TMREPO_DIR + '/Bundles'})
#puts `svn up #{TMREPO_DIR + '/Support'}`

# Delete old transit dirs
#rm_rf(TRANSIT_DIR + '/Bundles')
#rm_rf(TRANSIT_DIR + '/Support')

# Export to transit dir
#puts `svn export #{TMREPO_DIR + '/Bundles'} #{TRANSIT_DIR}/Bundles`
#puts `svn export #{TMREPO_DIR + '/Support'} #{TRANSIT_DIR}/Support`

# Sanitize the transit dir
Find.find(TRANSIT_DIR) do |f| 
   orig_name = File.basename(f)
   clean_name = sanitize(File.basename(f))
   #Kernel.raise "Found illegal char in supposedly clean: " + clean_name if clean_name =~ /[^[:ascii:]]/
   dirname = File.dirname(f) + "/"
   verbose_rename(dirname + orig_name, dirname + clean_name) unless (orig_name === clean_name)
end

