# _plugins/fix_file_exists.rb
class File
  class << self
    alias_method :exists?, :exist?
  end
end