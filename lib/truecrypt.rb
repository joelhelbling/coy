class TrueCrypt

  def self.create_volume(p={})

    volume_name   = p[:file_name]
    mount_point   = p[:short_name]
    volume_type   = p[:volume_type]   || 'normal'
    size          = p[:size_in_bytes] || 5_000_000  # 5Mb
    encryption    = p[:encryption]    || 'AES'
    hash          = p[:hash]          || 'Whirlpool'
    keyfiles      = p[:keyfiles]      || '""'
    random_source = p[:random_source] || __FILE__
    password      = p[:password]      || raise("Please provide a password")
    filesystem    = p[:filesystem]    || 'FAT'

    command = <<-TC
      truecrypt --text                   \
        --create #{volume_name}          \
        --volume-type=#{volume_type}     \
        --size=#{size}                   \
        --encryption=#{encryption}       \
        --hash=#{hash}                   \
        --filesystem=#{filesystem}       \
        --password=#{password}           \
        --keyfiles=#{keyfiles}           \
        --random-source=#{random_source}
    TC

    puts `pwd`
    `#{command}`
  end

  # if no password provided, gui window will pop up
  def self.open(p={})
    file_name = p[:file_name] || raise("You must provide the name of the volume you wish to open")
    short_name = p[:short_name]
    pwd_param = p[:password] && "--password=#{p[:password]}"
    `truecrypt #{file_name} #{pwd_param} #{short_name}`
  end

  def self.close(p={})
    file_name = p[:file_name] || raise("You must provide the name of the volume you wish to close")
    `truecrypt -d #{file_name}`
  end

end

