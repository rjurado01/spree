module SpreeCmd
  class Extension < Thor::Group
    include Thor::Actions

    desc 'builds a spree extension'
    argument :file_name, type: :string, desc: 'rails app_path', default: 'sample_extension'

    source_root File.expand_path('templates/extension', __dir__)

    def generate
      use_prefix 'spree_'

      empty_directory file_name

      directory 'app',      "#{file_name}/app"
      directory 'lib',      "#{file_name}/lib"
      directory 'bin',      "#{file_name}/bin"
      directory 'spec',     "#{file_name}/spec"

      chmod "#{file_name}/bin/rails", 0o755

      template 'extension.gemspec', "#{file_name}/#{file_name}.gemspec"
      template 'Gemfile', "#{file_name}/Gemfile"
      template 'gitignore', "#{file_name}/.gitignore"
      template 'LICENSE', "#{file_name}/LICENSE"
      template 'Rakefile', "#{file_name}/Rakefile"
      template 'README.md', "#{file_name}/README.md"
      template 'config/routes.rb', "#{file_name}/config/routes.rb"
      template 'config/locales/en.yml', "#{file_name}/config/locales/en.yml"
      template 'rspec', "#{file_name}/.rspec"
      template 'travis.yml', "#{file_name}/.travis.yml"
      template '.rubocop.yml', "#{file_name}/.rubocop.yml"
    end

    def final_banner
      say %{
        #{'*' * 80}

        Congrats, Your extension has been generated :rocket:

        Next steps:
        * Read Spree Developer Documentation at: https://dev-docs.spreecommerce.org/customization
        * Start your extension at: https://dev-docs.spreecommerce.org/extensions/extensions

        #{'*' * 80}
      }
    end

    no_tasks do
      def class_name
        Thor::Util.camel_case file_name
      end

      def use_prefix(prefix)
        @file_name = prefix + Thor::Util.snake_case(file_name) unless file_name =~ /^#{prefix}/
      end
    end
  end
end
