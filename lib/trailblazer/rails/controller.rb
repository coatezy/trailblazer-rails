module Trailblazer::Rails
  module Controller
    def run(operation, params=self.params, *dependencies)
      result = operation.(params, *dependencies)

      @form = Trailblazer::Rails::Form.new(result["contract.default"], result["model"].class)
      @model = result["model"]

      yield(result) if result.success? && block_given?

      @_result = result
    end

    module Render
      def render(options={}, *args, &block)
        return render_cell(options) if options[:cell]
        super
      end

      def render_cell(options)
        options = options.reverse_merge(layout: true)

        # render the cell.
        content = cell(options[:cell], options[:model], options[:options] || {})

        render( { html: content }.merge(options.except(:cell, :model, :options)) )
      end
    end

    include Render
  end
end
