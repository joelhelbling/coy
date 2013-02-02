module CleanupTruecrypt
  def remember_we_opened(vol_name)
    @opened_tc_volumes ||= []
    @opened_tc_volumes << vol_name
  end

  def close_all_opened_tc_volumes
    @opened_tc_volumes && @opened_tc_volumes.each do |vol|
      print "    # CLEANUP: was truecrypt volume \"#{vol}\" closed?  "
      if File.directory? File.join('tmp', 'aruba', vol)
        print "No, shutting it down now..."
        step "let's cleanup \"#{vol}\""
      else
        print "Yes."
      end
    end
  end
end

World CleanupTruecrypt

