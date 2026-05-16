# frozen_string_literal: true

require 'gems'

class TarballsController < ActionController::API
  rate_limit to: 10, within: 1.second, name: 'short-term'
  rate_limit to: 100, within: 2.minutes, name: 'long-term'

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def show
    package = Registry::Package.finreate!(params[:name], params[:version])

    redirect_to Registry::SignTarball.new(package).url, allow_other_host: true
  end

  private

    def render_not_found(message)
      render json: { error: message }, status: :not_found
    end
end
