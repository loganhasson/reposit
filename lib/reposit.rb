require "reposit/version"

module Reposit
  class RepositoryMaker
    attr_reader :repo_name

    def initialize(repo_name)
      @repo_name = repo_name
    end

    def run(repo_name)
      new(repo_name).create
    end

    def create
      credential_reader = CredentialsReader.new
      username = credential_reader.username
      api_key = credential_reader.api_key
      `curl -s -u '#{username}:#{api_key}' https://api.github.com/user/repos -d "{\"name\":\"#{repo_name}\"}" | sed -n '/"ssh_url"/p' | gawk 'match($0, /:{1}\s"(.*)"/, ary) {print ary[1]}' | pbcopy`
    end
  end

  class SetupChecker
    attr_reader :lines

    def initialize
      @lines = 0
    end

    def self.check
      new.check
    end

    def check
      if file_exists?
        has_two_lines? && both_lines_have_text?
      else
        false
      end
    end

    def file_exists?
      File.exist?('~/.reposit')
    end

    def has_two_lines?
      self.lines = Reposit::CredentialsReader.new.get_credentials
      lines.size == 2
    end

    def both_lines_have_text?
      lines.all? {|line| line && line.size > 0}
    end
  end

  class CredentialsReader
    attr_reader :username, :api_key

    def initialize
      @username, @api_key = get_credentials
    end

    def get_credentials
      File.readlines('~/.reposit').map do |credential|
        credential
      end
    end
  end

  class CredentialsSetter
    attr_reader :username, :api_key

    def run
      print "GitHub username: "
      self.username = gets.chomp
      puts ""
      print "API Key: "
      self.api_key = gets.chomp
      write_credentials
    end

    def write_credentials
      File.open('~/.reposit', 'w+') do |f|
        f.write username + '\n'
        f.write api_key
      end
    end
  end
end
