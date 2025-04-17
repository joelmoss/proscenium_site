# frozen_string_literal: true

require 'gems'

class PackagesController < ActionController::API
  rate_limit to: 10, within: 1.second, name: 'short-term'
  rate_limit to: 100, within: 2.minutes, name: 'long-term'

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index = render json: {}

  def show
    render json: Registry::Package.finreate!(package_params[:name], package_params[:version])
  end

  private

  def render_not_found(message)
    render json: { error: message }, status: :not_found
  end

  def package_params
    @package_params ||= params.permit(:name, :version)
  end
end
