#!/usr/bin/ruby -w
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
system("svn up #{TMREPO_DIR + '/Bundles'}")
system("svn up #{TMREPO_DIR + '/Support'}")

# Delete old transit dirs
rm_rf(TRANSIT_DIR + '/Bundles')
rm_rf(TRANSIT_DIR + '/Support')

# Export to transit dir
puts `svn export #{TMREPO_DIR + '/Bundles'} #{TRANSIT_DIR}/Bundles`
puts `svn export #{TMREPO_DIR + '/Support'} #{TRANSIT_DIR}/Support`

# Sanitize the transit dir
bad_dirs = []
Find.find(TRANSIT_DIR) do |f| 
  orig_name = File.basename(f)
  next if orig_name === (clean_name = sanitize(File.basename(f)))
  #Kernel.raise "Found illegal char in supposedly clean: " + clean_name if clean_name =~ /[^[:ascii:]]/
	if File.directory? f
		bad_dirs.push(f)
		next
	end
  dirname = File.dirname(f) + "/"
  verbose_rename(dirname + orig_name, dirname + clean_name) unless (orig_name === clean_name)
end

puts "Renaming #{bad_dirs.size} dirs..."
bad_dirs.each do |d|
	orig_name = File.basename(d)
	clean_name = sanitize(File.basename(d))
	dirname = File.dirname(d) + "/"
	verbose_rename(dirname + orig_name, dirname + clean_name)
end

# Sync transit dir and tmbundles4win dir
system("rsync --archive --exclude .svn --verbose #{TRANSIT_DIR}/ #{WINREPO_DIR}/trunk")

# Commit tmbundles4win
puts "Adding new files..."
system("svn add #{WINREPO_DIR}/trunk/* --force")
 
puts "Checking in Bundles (batched in case we get a very large checkin)..."
("a".."z").each do |a|
	puts "#{WINREPO_DIR}/trunk/Bundles/#{a} and " + a.upcase + "..."
	system("svn ci #{WINREPO_DIR}/trunk/Bundles/#{a}* -m \"Sync #{a}... #{Time.now()}\"")
	system("svn ci #{WINREPO_DIR}/trunk/Bundles/#{a.upcase}* -m \"Sync #{a}... at #{Time.now()}\"")
end

puts "Final checkin of trunk/ to make sure we got everything..."
system("svn ci #{WINREPO_DIR}/trunk/ -m \"Sync at #{Time.now()}\"")

