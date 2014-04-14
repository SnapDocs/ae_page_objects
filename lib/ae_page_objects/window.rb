require 'ae_page_objects/window/handle_manager'

module AePageObjects
  class Window
    class << self
      def all
        @windows ||= Windows.new
      end

      def close_all
        all.close_all
      end
    end

    attr_reader :current_document, :handle

    def initialize(registry, handle)
      @registry         = registry
      @handle           = handle
      @current_document = nil

      @registry.add(self)
    end

    def current_document=(document)
      @current_document.send(:stale!) if @current_document
      @current_document = document
    end

    def switch_to
      HandleManager.switch_to(handle)
      current_document
    end

    def document_as(*document_classes, &block)
      VariableDocument.new(DocumentQuery.new(*document_classes, &block))
    end

    def close
      if HandleManager.close(@handle)
        self.current_document = nil
        @registry.remove(self)
      end
    end
  end
end
