# frozen_string_literal: true

class CodeStageComponent < ApplicationComponent
  def view_template(&)
    div class: :@base do
      div(&)
    end
  end
end
