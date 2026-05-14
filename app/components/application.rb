# frozen_string_literal: true

class Components::Application < Phlex::HTML
  include Proscenium::Phlex::IncludeAssets
  include Proscenium::Phlex::CssModules
  include Proscenium::Phlex::Sideload
  include Phlexible::Rails::AElement

  self.abstract_class = true

  extend Literal::Properties

  delegate :request, :controller, :params, to: :view_context
end
