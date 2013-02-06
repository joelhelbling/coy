module Coy
  class Gitignore
    IGNORE_FILE = './.gitignore'
    REPO_DIR    = './.git'
    COY_DIR     = ".coy"

    class << self
      def guard_ignorance(vol_name)
        if its_a_repo?
          unless ignore_file_exists?
            raise NoGitignoreFile.new("This project has no .gitignore file!")
          end
          unless coy_ignored?
            raise CoyNotIgnored.new ".gitignore does not include '.coy'"
          end
          unless protected_dir_ignored? vol_name
            raise ProtectedDirNotIgnored.new(
              ".gitignore does not include protected directory \"#{vol_name}\"" )
          end
        end
      end

      def its_a_repo?
        Dir.exists? REPO_DIR
      end

      def ignore_file_exists?
        File.exists?(IGNORE_FILE)
      end

      def coy_ignored?
        gitignored.include? COY_DIR
      end

      def protected_dir_ignored?(vol_name)
        gitignored.include? vol_name
      end

      private

      def gitignored
        File.readlines(IGNORE_FILE).map(&:chomp)
      end
    end
  end

  class NoGitignoreFile < IOError; end
  class CoyNotIgnored < StandardError; end
  class ProtectedDirNotIgnored < StandardError; end
end
