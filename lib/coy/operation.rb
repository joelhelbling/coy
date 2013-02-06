require 'truecrypt'
require 'coy/gitignore'

module Coy
  class Operation

    def initialize(action, p={})
      @action = action
      p[:short_name] ||= (p[:name] || p['name'])
      p[:file_name] = format_name(p[:short_name])
      p[:password] ||= p['password']
      @parameters = p
      send("parameters_for_#{@action}".to_sym)
    end

    def parameters_for_create
      @parameters[:size_in_bytes] ||= 2_000_000
      @parameters[:encryption]    ||= 'AES'
      @parameters[:hash]          ||= 'Whirlpool'
      @parameters[:keyfiles]      ||= '""'

      # truecrypt bug: Mac OS Extended filesystem
      # doesn't work with the --text interface
      @parameters[:filesystem] = 'FAT'
    end

    def parameters_for_open
      # no special parameters for open
    end

    def parameters_for_close
      # no special parameters for close
    end

    def go
      Gitignore.guard_ignorance @parameters[:short_name]
      if @action == :create
        ensure_coy_directory_exists
        TrueCrypt.create_volume(@parameters) &&
        puts("Protected directory \"#{@parameters[:short_name]}\" successfully created.")
      end
      TrueCrypt.open(@parameters) if @action == :open
      TrueCrypt.close(@parameters) if @action == :close
    end

    private

    def format_name(name='secrets')
     ".coy/#{name.gsub(/\.tc$/,'')}.tc"
    end

    def ensure_coy_directory_exists
      unless File.directory?('./.coy')
        puts "Creating .coy subdirectory..."
        Dir.mkdir('.coy')
      end
    end

  end
end

