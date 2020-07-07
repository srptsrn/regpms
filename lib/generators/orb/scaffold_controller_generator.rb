require 'rubygems/specification'
require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'

module Orb
  module Generators
    class ScaffoldControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      check_class_collision suffix: "Controller"

      check_class_collision suffix: "ControllerTest"

      check_class_collision suffix: "Helper"

      class_option :orm, banner: "NAME", type: :string, required: true,
                   desc: "ORM to generate the controller for"

      class_option :html, type: :boolean, default: true,
                   desc: "Generate a scaffold with HTML output"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def initialize(args, *options) #:nodoc:
        if options[0]
          @namespace = options[0].select {|opt| opt.to_s.include?("--namespace=")}.first.to_s.gsub("--namespace=", "")
        end
        super
      end

      hook_for :resource_route, in: :rails do |resource_route|
        invoke resource_route, [orb_class_name]
      end

      def create_controller_files
        template "controllers/controller.rb", (prefix ? File.join('app/controllers', prefix, class_path, "#{controller_file_name}_controller.rb") : File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb"))
      end

      def create_test_files
        template "tests/test_unit/functional_test.rb", (prefix ? File.join("test/controllers", prefix, controller_class_path, "#{controller_file_name}_controller_test.rb") : File.join("test/controllers", controller_class_path, "#{controller_file_name}_controller_test.rb"))
      end

      hook_for :helper, in: :rails do |helper|
        invoke helper, [orb_controller_class_name]
      end

      def create_root_folder
        empty_directory (prefix ? File.join("app/views", prefix, controller_file_path) : File.join("app/views", controller_file_path))
      end

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          template "views/#{filename}", (prefix ? File.join("app/views", prefix, controller_file_path, filename) : File.join("app/views", controller_file_path, filename)) unless view == "update"
          if %w(index show).include? view
            template "views/#{view}.json.jbuilder.erb", (prefix ? File.join("app/views", prefix, controller_file_path, "#{view}.json.jbuilder") : File.join("app/views", controller_file_path, "#{view}.json.jbuilder")) 
          end
          if %w(edit show update).include? view
            template "views/#{view}.js.erb", (prefix ? File.join("app/views", prefix, controller_file_path, "#{view}.js.erb") : File.join("app/views", controller_file_path, "#{view}.js.erb"))
          end
        end
        template "locales/models/model.yml.erb", File.join("config/locales/models", "#{singular_table_name}.yml")
      end

      def available_views
        # %w(index edit update show new _form _index_row _index_row_form _nested_form _nested_fields _search_list _chosen_select _widget)
        %w(index edit update show new _form _nested_form _nested_fields _chosen_select)
      end

      hook_for :assets, in: :rails do |assets|
        invoke assets, [orb_class_name]
      end

      protected

      def prefix
        !@namespace.blank? ? @namespace : nil
      end
      
      def prefix_capitalize
        prefix.split('_').collect {|pf| pf.capitalize}.join
      end

      def orb_class_name
        prefix ? "#{prefix_capitalize}::#{class_name}" : class_name
      end

      def orb_controller_class_name
        prefix ? "#{prefix_capitalize}::#{controller_class_name}" : controller_class_name
      end

      def orb_route_url
        prefix ? "/#{prefix}#{route_url}" : route_url
      end

      def orb_plain_model_url
        prefix ? "#{prefix}_#{singular_table_name}" : singular_table_name
      end

      def orb_plural_model_url
        prefix ? "#{prefix}_#{plural_table_name}" : plural_table_name
      end

      def orb_index_helper
        prefix ? "#{prefix}_#{index_helper}" : index_helper
      end

      def format
        :html
      end

      def filename_with_extensions(name)
        [name, format, :erb].compact.join(".")
      end

      # Add a class collisions name to be checked on class initialization. You
      # can supply a hash with a :prefix or :suffix to be tested.
      #
      # ==== Examples
      #
      #   check_class_collision suffix: "Decorator"
      #
      # If the generator is invoked with class name Admin, it will check for
      # the presence of "AdminDecorator".
      #
      def self.check_class_collision(options={})
        define_method :check_class_collision do
          name = if self.respond_to?(:orb_controller_class_name) # for ScaffoldBase
            orb_controller_class_name
          elsif self.respond_to?(:controller_class_name) # for ScaffoldBase
            controller_class_name
          else
            class_name
          end

          class_collisions "#{options[:prefix]}#{name}#{options[:suffix]}"
        end
      end

      def attributes_hash
        return if attributes_names.empty?

        attributes_names.map do |name|
          if %w(password password_confirmation).include?(name) && attributes.any?(&:password_digest?)
            "#{name}: 'secret'"
          else
            "#{name}: @#{singular_table_name}.#{name}"
          end
        end.sort.join(', ')
      end

      def attributes_list_with_timestamps
        attributes_list(attributes_names + %w(created_at updated_at))
      end

      def attributes_list(attributes = attributes_names)
        if self.attributes.any? {|attr| attr.name == 'password' && attr.type == :digest}
          attributes = attributes.reject {|name| %w(password password_confirmation).include? name}
        end

        attributes.map { |a| ":#{a}"} * ', '
      end

    end
  end
end
