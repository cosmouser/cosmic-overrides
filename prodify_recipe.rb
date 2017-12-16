require 'plist'

# script for making prod style overrides of .jss autopkg recipes
# usage: ruby prodify_recipe.rb path_to_recipe
# it will drop the override in the same directory as the specified file
path = ARGV[0]
ARGV.clear
# store the path of the plist to create
prodified_path = path.slice(0..-12) + "-socsciprod.jss.recipe"

# change CATEGORY from Productivity to a list of currently available categories
categories = %w(Maintenance Printers Scripts Security Software Tasks Testing Unknown Utilities)

puts "Enter the number for the desired category"
categories.map {|x| puts "#{categories.index(x)} - #{x}"}
# 0 - Digital Media
# 1 - Maintenance
# 2 - Printers
# 3 - etc.
category = gets

recipe = Plist.parse_xml(path)
# change Identifier from local.jss.appname to local.jss.appname-socsciprod
recipe['Identifier'] = "#{recipe['Identifier']}-socsciprod"

# load the override - ruby prodify_recipe.rb appname.jss.recipe
recipe = Plist.parse_xml(path)

# set the category to what the user specified earlier
recipe['Input']['CATEGORY'] = categories[category.to_i]

# change GROUP_NAME from %NAME%-update-smart to Current OS
recipe['Input']['GROUP_NAME'] = "Current OS"

# change GROUP_TEMPLATE from SmartGroupTemplate.xml to CurrentOSTemplate.xml
recipe['Input']['GROUP_TEMPLATE'] = "CurrentOSTemplate.xml"

# change POLICY_CATEGORY from Testing to CATEGORY
recipe['Input']['POLICY_CATEGORY'] = recipe['Input']['CATEGORY']

# write changes
prodified_recipe = File.new(prodified_path, "w")
prodified_recipe.write recipe.to_plist
prodified_recipe.close
