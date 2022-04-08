puts "Creating link_tags"
tags = LinkTag.create([
  { name: 'Film' }, { name: 'Work' }, {name: 'School'},
  { name: 'Project' }, { name: 'Team' }, {name: 'Company'}
])
puts "End create link_tags"
