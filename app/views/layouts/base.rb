# frozen_string_literal: true

class Views::Layouts::Base < Phlex::HTML
  include Proscenium::Phlex::IncludeAssets
  include Proscenium::Phlex::CssModules
  include Proscenium::Phlex::Sideload

  self.abstract_class = true

  include Phlexible::Rails::ControllerVariables
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::CSPMetaTag
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::StylesheetLinkTag
  include Phlex::Rails::Helpers::AssetURL

  extend Literal::Properties

  delegate :request, :controller, :params, to: :view_context

  prop :view, _Any, :positional

  # Helper method to get the CSP nonce for the current request. Rails automatically generates and
  # includes this in the CSP header.
  def csp_nonce
    @csp_nonce ||= view_context.content_security_policy_nonce
  end

  def view_template(&)
    doctype
    html do
      head
      body(&)
    end
  end

  def page_title = view_context.breadcrumbs_for_title(primary: true).presence || 'Proscenium'

  def head
    super do
      # Page title is first taken from the view if defined, then from the controller, then from the
      # layout.
      title { @view&.try(:page_title) || controller.try(:page_title) || page_title }

      # include_sentry

      yield if block_given?

      csp_meta_tag
      csrf_meta_tags
      render Phlexible::Rails::MetaTagsComponent

      link rel: 'apple-touch-icon', sizes: '180x180', href: '/apple-touch-icon.png'
      # link rel: 'icon', type: 'image/png', sizes: '32x32', href: '/favicon-32x32.png'
      # link rel: 'icon', type: 'image/png', sizes: '16x16', href: '/favicon-16x16.png'
      # link rel: 'shortcut icon', href: '/favicon.ico', type: 'image/x-icon'

      # include_common_styles
      # style { Rouge::Themes::Base16.mode(:dark).render(scope: '.highlight') }
      include_assets
    end
  end

  # def body(**)
  #   super do
  #     # https://stackoverflow.com/questions/14389566/stop-css-transition-from-firing-on-page-load
  #     script(type: 'text/javascript', nonce: csp_nonce) { ' ' } if !request.sheet?

  #     yield if block_given?
  #   end
  # end

  private

    # Include the common styles for all pages. This is used to include styles that are shared across
    # multiple layouts. It also ensures critical styles are included first.
    def include_common_styles
      filepath = Rails.root.join('lib/common.css').to_s
      filepath = Array(Proscenium::Resolver.resolve(filepath)).first
      stylesheet_link_tag(filepath.delete_prefix('/'), extname: false)
    end
end
