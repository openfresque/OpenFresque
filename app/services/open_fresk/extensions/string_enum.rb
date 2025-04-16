# frozen_string_literal: true

module OpenFresk
  module Extensions
    module StringEnum
      extend ActiveSupport::Concern

      module ClassMethods
        # string_enum allow a developer to define a set of named constants
        #
        # ==== Examples
        #
        #   class User
        #     include StringEnum
        #
        #     string_enum role: %i[employee admin manager]
        #
        #     # automaticaly include validation
        #     # validates(:role, inclusion: { in: ['EMPLOYEE', 'ADMIN', 'MANAGER'] }, allow_nil: true)
        #   end
        #
        #   define all methods bellow:
        #
        #   user.employee?
        #   user.admin?
        #   user.manager?
        #
        #   user.employee!
        #   user.admin!
        #   user.manager!
        #
        #   User::Employee # => 'EMPLOYEE'
        #   User::Admin # => 'ADMIN'
        #   User::Manager # => 'MANAGER'
        #
        #   User.employees # => [<#User role='EMPLOYEE'>, <#User role='EMPLOYEE'>]
        #   User.admin # => [<#User role='ADMIN'>, <#User role='ADMIN'>]
        #   User.manager # => [<#User role='MANAGER'>, <#User role='MANAGER'>]
        #
        #   User.role_with(<KEYS>)
        #   User.role_with([:admin, :manager]) # => [<#User role='MANAGER'>, <#User role='ADMIN'>]
        #
        #   User.role_keys # => [:employee, :admin, :manager]
        #   User.role_values # => ['EMPLOYEE', 'ADMIN', 'MANAGER']
        #
        #   User.enum_value_for(role: <KEY>)
        #   User.enum_value_for(role: :employee) # => 'EMPLOYEE'
        #
        #   User.role_value_for(<key>)
        #   User.role_value_for(:employee) # => 'EMPLOYEE'
        #
        def string_enum(validation: true, prefix: false, **enum_hash)
          # enum_name = :role
          enum_name = enum_hash.keys.first

          # enum_keys = [:employee, :admin, :manager]
          enum_keys = enum_hash[enum_name].freeze

          # enum_keys_values = { employee: 'EMPLOYEE', admin: 'ADMIN', manager: 'MANAGER' }
          enum_keys_values = enum_keys.index_with(&key_to_value)

          # enum_values = ['EMPLOYEE', 'ADMIN', 'MANAGER']
          enum_values = enum_keys_values.values

          define_enum_methods(enum_name, enum_keys, enum_values, enum_keys_values, prefix)

          # HACK: we want validation to be overridable while implementing framework
          # To do that, each time we are overriding string enum, we must
          #   * Remove validations callback already set by ancestor's definition of string enum
          #   * Remove the validations from the list of classes validators
          #
          # find previously defined inclusion validation callback:
          previous_validation_callback =
            send(:get_callbacks, :validate)
            .send(:chain)
            .filter do |c|
              c.filter.is_a?(ActiveModel::Validations::InclusionValidator) && c.filter.attributes.include?(enum_name)
            end.first

          # if such callback exists
          if previous_validation_callback.present?
            # get rid of it
            send(:get_callbacks, :validate).send(:chain).delete(previous_validation_callback)
            # remove the validation from classes validators
            _validators[enum_name].delete_if { |v| v.instance_of?(ActiveModel::Validations::InclusionValidator) }
          end

          # implement validation based on current enum
          # if validation is set to false, we've cleared inclusion validations on current enum
          #
          # validates(:role, inclusion: { in: ['EMPLOYEE', 'ADMIN', 'MANAGER'] }, allow_nil: true)
          validates(enum_name, inclusion: {in: enum_values}, allow_nil: true) if validation
        end

        private

          def key_to_value
            ->(key) { key.to_s.upcase }
          end

          def define_enum_methods(enum_name, enum_keys, enum_values, enum_keys_values, prefix)
            # for each keys define named methodes
            enum_keys_values.each { |enum_key, enum_value| define_named_methodes(enum_name, enum_key, enum_value, prefix) }

            # class.role_with(<KEYS>)
            #
            # def self.role_with([:admin, :manager])
            #   where(role: ['ADMIN', 'MANAGER'])
            # end
            define_singleton_method("#{enum_name}_with") do |*keys|
              where(enum_name => Array(keys).flatten.map(&key_to_value))
            end

            # class.role_keys
            #
            # def self.role_keys
            #   [:employee, :admin, :manager]
            # end
            define_singleton_method("#{enum_name}_keys") { enum_keys }

            # instance.role_keys
            delegate("#{enum_name}_keys".to_sym, to: :class)

            # class.role_values
            #
            # def self.role_values
            #   ['EMPLOYEE', 'ADMIN', 'MANAGER']
            # end
            define_singleton_method("#{enum_name}_values") { enum_values }

            # instance.role_values
            delegate("#{enum_name}_values".to_sym, to: :class)

            define_enum_value_methods(enum_name, enum_keys, enum_keys_values)
          end

          def define_enum_value_methods(enum_name, enum_keys, enum_keys_values)
            # class.enum_value_for(<enum_name>: <key>)
            #
            # def self.enum_value_for(role: :employee)
            #  'EMPLOYEE'
            # end
            define_singleton_method(:enum_value_for) do |**args|
              public_send("#{args.keys.first}_enum_value_for", args.values.first)
            end

            # class.<enum_name>_enum_value_for(<key>)
            #
            # def self.role_enum_value_for(:employee)
            #  'EMPLOYEE'
            # end
            define_singleton_method("#{enum_name}_enum_value_for") do |enum_key|
              enum_key = enum_key.to_sym
              raise(ArgumentError, "unknown enum_key: #{enum_key}") unless enum_keys.include?(enum_key)

              enum_keys_values[enum_key]
            end
          end

          def define_named_methodes(enum_name, enum_key, enum_value, prefix)
            # instance.<key>?
            #
            # def employee?
            #  role == 'EMPLOYEE'
            # end
            define_method("#{enum_key}?") { public_send(enum_name) == enum_value }

            # instance.<key>!
            #
            # def employee!
            #  self.role = 'EMPLOYEE'
            # end
            define_method("#{enum_key}!") { public_send("#{enum_name}=", enum_value) }

            # class::<Key>
            #   the class name follow by key as camelcase
            #
            # class::Employee
            #  => 'EMPLOYEE'
            define_constant(enum_key, prefix ? enum_name : false)

            # def self.employees
            #   where(role: 'EMPLOYEE')
            # end
            define_singleton_method(enum_key.to_s.pluralize) { where(enum_name => enum_value) }
          end

          def define_constant(enum_key, prefix)
            prefix = prefix ? prefix.to_s + "_" : ""
            constant_name = (prefix + enum_key.to_s).camelcase
            return if const_defined?(constant_name, false)

            const_set(
              constant_name,
              enum_key.to_s.underscore.upcase
            )
          end
      end
    end
  end
end