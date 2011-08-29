module Reservoir
  
  class VersionAnalyzer
    
    attr_accessor :version_info, :version, :version_parts
    
    def read(version_info)
      @version_info = version_info
      
      major_minor_revision_match = /(\d*)\.(\d*)\.(\d*)/
      mmr_patchlevel_match = /(\d*)\.(\d*)\.(\d*).*(patchlevel)\s*(\d*)/
      
      
      m = version_info.match(mmr_patchlevel_match)
      unless m.nil?
        @version_parts = [ m[1], m[2], m[3], m[5] ] 
        @version = @version_parts[0..2].join(".") + "-p" + m[5]
        return
      end
      
      m = version_info.match(major_minor_revision_match)
      unless m.nil?
        @version_parts = [ m[1], m[2], m[3] ] 
        @version = @version_parts.join(".")
        return
      end
      
    end
    
  end

end