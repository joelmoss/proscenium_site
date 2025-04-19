# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Phlexible::Rails::ActionController::ImplicitRender

  allow_browser versions: :modern
end
