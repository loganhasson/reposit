require "reposit/version"
require "json"

module Reposit
  class RepositoryMaker
    attr_reader :repo_name

    def initialize(repo_name)
      @repo_name = repo_name
    end

    def self.run(repo_name)
      new(repo_name).create
    end

    def create
      credential_reader = CredentialsReader.new
      username = credential_reader.username
      api_key = credential_reader.api_key
      conn = Faraday.new(url: 'https://api.github.com') do |faraday|
        faraday.adapter  Faraday.default_adapter
        faraday.basic_auth(username, api_key)
      end

      response = conn.post do |req|
        req.url '/user/repos'
        req.body = "{ \"name\": \"#{repo_name}\" }"
      end

      copy_response(response)
    end

    def copy_response(response)
      original_stdout = $stdout
      $stdout = fake = StringIO.new
      
      begin
        ap JSON.parse(response.body)
      ensure
        $stdout = original_stdout
      end

      File.open('temp_response', 'w+') do |f|
        f.write fake.string
      end

      `sed -n '/"ssh_url"/p' temp_response | gawk 'match($0, /m{1}"(.*)"/, ary) {print ary[1]}' | pbcopy`

      FileUtils.rm('temp_response')
    end
  end

  class SetupChecker
    attr_accessor :lines

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
      File.exist?(File.expand_path('~') + '/.reposit')
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
      File.readlines(File.expand_path('~') + '/.reposit').map do |credential|
        credential.strip
      end
    end
  end

  class CredentialsSetter
    attr_accessor :username, :api_key

    def initialize
      @username, @api_key = "", ""
    end
    
    def self.run
      new.run
    end

    def run
      print "GitHub username: "
      self.username = $stdin.gets.chomp
      print "API Key: "
      self.api_key = $stdin.gets.chomp
      write_credentials
    end

    def write_credentials
      File.open(File.expand_path('~') + '/.reposit', 'w+') do |f|
        f.puts username
        f.write api_key
      end
    end
  end
end
