#!/usr/bin/env ruby
# if the metadata.rb is missing, uploads fail.
require 'json'

tehmap = {
'name' => 'name',
'version' => 'version',
'description' => 'description',
'long_description' => 'long_description',
'maintainer' => 'maintainer',
'maintainer_email' => 'maintainer_email',
'license' => 'license',
'platforms' => 'supports',
'dependencies' => 'depends',
'recommendations' => 'recommends',
'suggestions' => 'suggests',
'conflicting' => 'conflicts',
'providing' => 'provides',
'replacing' => 'replaces',
'attributes' => 'attribute',
'groupings' => 'grouping',
'recipes' => 'recipe'
}

md = JSON.parse(ARGF.read)
md.each do |key, value|
 if key == "attributes"
   next
 elsif value.is_a?(Hash)
   value.each do |k, v|
     puts "#{tehmap[key]} '#{k}', '#{v}'"
   end
 elsif value.is_a?(Array)
   value.each do |v|
     puts "#{tehmap[key]} '#{v}'"
   end
 elsif key == "long_description"
   puts "long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))"
 elsif tehmap[key]
   puts "#{tehmap[key]} '#{value}'"
 end
end
