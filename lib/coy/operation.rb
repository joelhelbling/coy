require 'highline'
require 'ignorance'
require 'truecrypt'

module Coy
  class Operation

    COY_DIR = '.coy'
    COY_COMMENT = "added by coy"

    def initialize(action, p={})

      guard_truecrypt_installed

      @action = action
      p[:short_name] ||= (p[:name] || p['name'])
      p[:file_name]    = format_name(p[:short_name])
      p[:password]   ||= p['password']
      @parameters = p
      send("parameters_for_#{@action}".to_sym)
      Ignorance.negotiate COY_DIR, COY_COMMENT
      Ignorance.negotiate @parameters[:short_name], COY_COMMENT
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
      send @action
    end

    private

    def create
      ensure_coy_directory_exists
      guard_password_provided "Please provide a password for protected director"
      TrueCrypt.create_volume(@parameters) &&
      puts("Protected directory \"#{@parameters[:short_name]}\" successfully created.")
    end

    def open
      if guard_volume_exists
        guard_password_provided
        TrueCrypt.open(@parameters)
      end
    end

    def close
      if guard_volume_exists
        TrueCrypt.close(@parameters)
      end
    end

    def format_name(name='secrets')
     "#{COY_DIR}/#{name.gsub(/\.tc$/,'')}.tc"
    end

    def guard_truecrypt_installed
      message = <<-ERROR
Coy requires TrueCrypt, but TrueCrypt is not installed! (Or at least it's not in the path.)

You can download TrueCrypt here: http://www.truecrypt.org/downloads

      ERROR
      raise message unless TrueCrypt.installed?
    end
    def ensure_coy_directory_exists
      unless File.directory?('./.coy')
        puts "Creating .coy subdirectory..."
        Dir.mkdir COY_DIR
      end
    end

    def guard_volume_exists
      volume_name = @parameters[:short_name]
      File.exists?("#{COY_DIR}/#{volume_name}.tc").tap do |volume_exists|
        unless volume_exists
          warn <<-WARN
There is no protected directory called "#{volume_name}" here.

You can create one by typing `coy create #{volume_name}`
          WARN
        end
      end
    end

    def guard_password_provided(msg_preamble="Please enter password for protected directory")
      unless @parameters[:password]
        @parameters[:password] = HighLine.new.ask("#{msg_preamble} \"#{@parameters[:name]}\":  ") {|x| x.echo = "*" }
      end
    end

  end
end

