class TrueCrypt

  def self.create_volume(p={})

    volume_name   = format_name p[:volume_name]
    volume_type   = p[:volume_type]   || 'normal'
    size          = p[:size_in_bytes] || 5000000  # 5Mb
    encryption    = p[:encryption]    || 'AES'
    hash          = p[:hash]          || 'Whirlpool'
    keyfiles      = p[:keyfiles]      || '""'
    random_source = p[:random_source] || __FILE__
    password      = p[:password]      || raise("Coy sez, \"what's the password?\"")
    filesystem    = 'FAT' # truecrypt bug: Mac OS Extended doesn't work with --text interface

    command = <<-TC
      truecrypt -t                   \
        --create #{volume_name}      \
        --volume-type=#{volume_type} \
        --size=#{size}               \
        --encryption=#{encryption}   \
        --hash=#{hash}               \
        --filesystem=#{filesystem}   \
        --password=#{password}       \
        --keyfiles=#{keyfiles}       \
        --random-source=#{random_source}
    TC

    ensure_coy_directory_exists

    `#{command}`
  end

  # if no password provided, gui window will pop up
  def self.open(name, password=nil)
    pwd_param = password && "--password=#{password}"
    `truecrypt .coy/#{name}.tc #{pwd_param} #{name}`
  end

  def self.close(name)
    `truecrypt -d .coy/#{name}.tc`
  end

  def self.close(name); lock(name); end

  private

  def self.format_name(name='secrets')
   "./.coy/#{name.gsub(/\.tc$/,'')}.tc"
  end

  def self.ensure_coy_directory_exists
    Dir.mkdir('.coy') unless File.directory?('./.coy')
  end
end

