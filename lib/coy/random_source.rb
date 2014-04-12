require 'net/http'

module Coy
  class RandomSource

    DEFAULT_FILE = "./random_source"

    def self.generate(file_name=DEFAULT_FILE)
      if block_given?
        File.open(file_name, 'w') { |fh| fh.write rand_strategy }
        yield file_name
        File.unlink(file_name)
      else
        rand_strategy
      end
    end

    def self.rand_strategy
      some_random_bytes.inject("") do |accumulator, random_bytes|
        accumulator.tap do |acc|
          acc << random_bytes.crypt(@prev.to_s.rjust(2, random_bytes).gsub(/[^\da-zA-Z]/,'x'))
          @prev = random_bytes.hash.to_s
        end
      end
    end

    def self.some_random_bytes
      (1500..2000).map{|number| rand(number).to_s }
    end
  end
end
