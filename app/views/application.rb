# frozen_string_literal: true

module Views
  class Application < Phlex::HTML
    include Proscenium::Phlex::IncludeAssets
    include Proscenium::Phlex::CssModules
    include Proscenium::Phlex::Sideload

    self.abstract_class = true

    include Phlexible::Rails::AutoLayout
    include Phlexible::Rails::ControllerVariables
    include Phlexible::Rails::AElement
    include Phlex::Rails::Helpers::Routes

    extend Literal::Properties

    delegate :request, :controller, :params, to: :view_context
  end
end
