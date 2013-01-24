class TrueCrypt

  def self.create_volume(p={})

    volume_name   = p[:name]
    volume_type   = p[:volume_type]   || 'normal'
    size          = p[:size_in_bytes] || 5_000_000  # 5Mb
    encryption    = p[:encryption]    || 'AES'
    hash          = p[:hash]          || 'Whirlpool'
    keyfiles      = p[:keyfiles]      || '""'
    random_source = p[:random_source] || File.path_rel(__FILE__)
    password      = p[:password]      || raise("Please provide a password")
    filesystem    = p[:filesystem]    || 'FAT'

    command = <<-TC
      truecrypt --text                   \
        --create #{name}                 \
        --volume-type=#{volume_type}     \
        --size=#{size}                   \
        --encryption=#{encryption}       \
        --hash=#{hash}                   \
        --filesystem=#{filesystem}       \
        --password=#{password}           \
        --keyfiles=#{keyfiles}           \
        --random-source=#{random_source}
    TC

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

end

