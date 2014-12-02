module Minimart
  module InventoryCookbook
    class GitCookbook < BaseCookbook

      attr_reader :name,
                  :url,
                  :branch,
                  :ref,
                  :tag

      def initialize(name, opts)
        super
        @branch = opts[:branch]
        @ref    = opts[:ref]
        @tag    = opts[:tag]
        @url    = opts[:url]
      end

      def location_specification?
        true
      end

      def cookbook
        @cookbook ||= fetch_cookbook
      end

      def requirements
        cookbook_info.dependencies
      end

      def cookbook_info
        cookbook.metadata
      end

      def cookbook_path
        cookbook.path
      end

      private

      def fetch_cookbook
        Configuration.output.puts "-- Downloading #{name}(#{commitish}) from #{url}"

        path = Download::GitRepository.new(url).download(commitish)
        Ridley::Chef::Cookbook.from_path(path)
      end

      def commitish
        ref || branch || tag
      end

    end
  end
end
