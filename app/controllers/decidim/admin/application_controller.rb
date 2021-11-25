# frozen_string_literal: true

module Decidim
  module Admin
    # The main application controller that inherits from Rails.
    class ApplicationController < ::DecidimController
      include NeedsOrganization
      include NeedsPermission
      include NeedsSnippets
      include FormFactory
      include LocaleSwitcher
      include UseOrganizationTimeZone
      include PayloadInfo
      include HttpCachingDisabler
      include DisableRedirectionToExternalHost

      helper Decidim::Admin::ApplicationHelper
      helper Decidim::Admin::AttributesDisplayHelper
      helper Decidim::Admin::SettingsHelper
      helper Decidim::Admin::IconLinkHelper
      helper Decidim::Admin::MenuHelper
      helper Decidim::Admin::ScopesHelper
      helper Decidim::Admin::Paginable::PerPageHelper
      helper Decidim::DecidimFormHelper
      helper Decidim::ReplaceButtonsHelper
      helper Decidim::ScopesHelper
      helper Decidim::TranslationsHelper
      helper Decidim::LanguageChooserHelper
      helper Decidim::ComponentPathHelper
      helper Decidim::SanitizeHelper

      after_action :flash_points

      default_form_builder Decidim::Admin::FormBuilder

      protect_from_forgery with: :exception, prepend: true

      register_permissions(::Decidim::Admin::ApplicationController,
                           ::Decidim::Admin::Permissions)

      def user_has_no_permission_path
        decidim_admin.root_path
      end

      def user_not_authorized_path
        decidim_admin.root_path
      end

      def permission_class_chain
        ::Decidim.permissions_registry.chain_for(::Decidim::Admin::ApplicationController)
      end

      def permission_scope
        :admin
      end

      def flash_points
        if(current_organization.assistant["flash"]!="")
          flash[:info]=current_organization.assistant["flash"]
          old_data = current_organization.assistant.dup
          flash_message = ""
          new_data = old_data.merge({
                                      flash: flash_message
                                    })
          current_organization.update!(assistant: new_data)
        end
      end
    end
  end
end
