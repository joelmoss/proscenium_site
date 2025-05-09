# frozen_string_literal: true

class ApplicationLayout < ApplicationView
  # include Phlex::Rails::Layout
  include Phlex::Rails::Helpers::CSPMetaTag
  include Phlex::Rails::Helpers::CSRFMetaTags

  # def markdown(content)
  #   render Phlex::Markdown.new(content.squish)
  # end

  def page_title = 'Proscenium'

  def around_template(&)
    doctype

    html do
      head do
        title { page_title }
        meta name: 'viewport', content: 'width=device-width,initial-scale=1'
        link rel: 'apple-touch-icon', sizes: '180x180', href: '/apple-touch-icon.png'
        link rel: 'icon', type: 'image/png', sizes: '32x32', href: '/favicon-32x32.png'
        link rel: 'icon', type: 'image/png', sizes: '16x16', href: '/favicon-16x16.png'
        link rel: 'mask-icon', href: '/safari-pinned-tab.svg', color: '#5bbad5'
        meta name: 'msapplication-TileColor', content: '#ffc40d'
        meta name: 'theme-color', content: '#ffffff'
        meta charset: 'utf-8'
        csrf_meta_tags
        csp_meta_tag
        include_assets

        # style { Rouge::Themes::Base16.mode(:dark).render(scope: '.highlight') }
      end

      body do
        super
      end
    end
  end
end
