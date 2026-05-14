# frozen_string_literal: true

module Views
  class Pages::Index < Application
    def view_template
      div class: :@base do
        img src: '/logo.svg', width: 352, height: 72
        a(href: 'https://github.com/joelmoss/proscenium') { 'Github Repo & Docs ❯❯' }
      end

      # div do
      #   render Phlex::Markdown.new <<-MARKDOWN.squish
      #     # Welcome to Phlex
      #   MARKDOWN
      # end
    end
  end
end
