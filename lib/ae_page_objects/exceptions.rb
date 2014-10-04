module AePageObjects
  class Error < StandardError; end

  class StalePageObject < Error
  end

  class LoadingFailed < Error
  end

  class LoadingPageFailed < LoadingFailed
  end

  class LoadingElementFailed < LoadingFailed
  end

  class ElementNotPresent < Error
  end

  class ElementNotAbsent < Error
  end

  class PathNotResolvable < Error
  end

  class DocumentLoadError < Error
  end

  class CastError < Error
  end

  class WindowNotFound < Error
  end
end
