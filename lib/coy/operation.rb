require 'truecrypt'

module Coy
  class Operation

    def initialize(action, p={})
      @action = action
      p[:name] = format_name(p[:name])
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
      TrueCrypt.create_volume(@parameters) if @action == :create
      TrueCrypt.open(@parameters) if @action == :open
      TrueCrypt.close(@parameters) if @action == :close
    end

    private

    def format_name(name='secrets')
     ".coy/#{name.gsub(/\.tc$/,'')}.tc"
    end

    def ensure_coy_directory_exists
      Dir.mkdir('.coy') unless File.directory?('./.coy')
    end

  end
end

