class Truecrypt

  def self.create_volume(p={})

    @volume_name   = format_name p[:volume_name]
    @volume_type   = p[:volume_type]   || 'normal'
    @size          = p[:size_in_bytes] || 5000000  # 5Mb
    @encryption    = p[:encryption]    || 'AES'
    @hash          = p[:hash]          || 'Whirlpool'
    @keyfiles      = p[:keyfiles]      || '""'
    @random_source = p[:random_source] || Coy::RandomSource.generate  # '.coy/random_source.txt'

    @password      = p[:password]      || raise "Coy sez, \"what's the password?\""

    @filesystem    = 'FAT' # truecrypt bug: Mac OS Extended doesn't work with --text interface

    `truecrypt -t \--create #@volume_name --volume-type=#@volume_type --size=#@size --encryption=#@encryption --hash=#@hash --filesystem=#@filesystem --password=#@password --keyfiles=#@keyfiles --random-source=#@random_source`
  end
end

  def self.unlock(name)
    `truecrypt .coy/#{name}.tc name`
  end

  def self.lock(name)
    `truecrypt -d .coy/#{name}.tc`
  end

  private

  def self.format_name(name='secrets')
   "./coy/#{name.gsub(/\.tc$/,'')}.tc"
  end
