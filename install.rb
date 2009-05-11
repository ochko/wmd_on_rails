FileUtils.cp_r(File.dirname(__FILE__) + '/javascripts/wmd',
  RAILS_ROOT + '/public/javascripts/')
FileUtils.cp(File.dirname(__FILE__) + '/stylesheets/wmd.css',
  RAILS_ROOT + '/public/stylesheets/')
FileUtils.cp(File.dirname(__FILE__) + '/images/grippie.png',
  RAILS_ROOT + '/public/images/')
