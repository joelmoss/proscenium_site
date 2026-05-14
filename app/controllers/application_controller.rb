# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Phlexible::Rails::ActionController::ImplicitRender
  include Phlexible::Rails::ActionController::MetaTags
  include Proscenium::UI::Breadcrumbs::Control

  layout false
  meta_tag 'viewport', 'width=device-width, initial-scale=1, shrink-to-fit=no'
  sideload_assets js: { type: 'module' }

  private

    def phlex_view_path(action_name) = "views/#{controller_path}/#{action_name}"
end
