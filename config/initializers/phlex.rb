# frozen_string_literal: true

# rubocop:disable Style/OneClassPerFile

module Views; end
module ViewConcerns; end
module ControllerConcerns; end
module ModelConcerns; end
module Components; end

root = Rails.root
loader = Rails.autoloaders.main

loader.push_dir("#{root}/app/components", namespace: Components)
loader.push_dir("#{root}/app/views", namespace: Views)

loader.push_dir("#{root}/app/views/concerns", namespace: ViewConcerns)
loader.push_dir("#{root}/app/controllers/concerns", namespace: ControllerConcerns)
loader.push_dir("#{root}/app/models/concerns", namespace: ModelConcerns)

# rubocop:enable Style/OneClassPerFile
