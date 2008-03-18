#!/usr/bin/ruby -w
BASEDIR = '/home/gtc/repos/tmbundles4win/Bundles/'

('C'..'Z').each do |l|
  puts `svn ci -m "Commit #{l}... bundles" #{BASEDIR + l}*`
end
