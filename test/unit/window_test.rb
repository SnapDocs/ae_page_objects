require 'unit_helper'

module AePageObjects
  class WindowTest < Test::Unit::TestCase
    def test_initialize
      window = Window.create("window_handle")
      assert_equal "window_handle", window.handle
      assert_nil window.current_document
      assert_equal window, Window.registry[window.handle]
    end

    def test_current_document=
      window = Window.create("window_handle")
      assert_nil window.current_document

      document_mock = mock(:stale! => true)
      window.current_document = document_mock

      assert_equal document_mock, window.current_document

      window.current_document = "whatever"
      assert_equal "whatever", window.current_document
    end

    def test_switch_to
      window = Window.create("window_handle")
      window.current_document = "current_document"

      navigator_mock = stub
      navigator_mock.expects(:window).with("window_handle")
      capybara_stub.browser.expects(:switch_to).returns(navigator_mock)

      assert_equal "current_document", window.switch_to
    end

    def test_close
      window = Window.create("window_handle")
      assert_equal window, Window.registry[window]

      document_mock = mock(:stale! => true)
      window.current_document = document_mock

      window.expects(:switch_to_window).yields
      capybara_stub.session.expects(:execute_script).with("window.close();")

      window.close

      assert_nil Window.registry[window]
    end

    def test_current__none
      capybara_stub.browser.expects(:window_handle).returns("window_handle")

      window = Window.current
      assert_equal window, Window.registry[window]
      assert_equal "window_handle", window.handle

      capybara_stub.browser.expects(:window_handle).returns("window_handle")
      assert_equal window, Window.current
    end

    def test_current__many
      window1 = Window.create("window_handle1")
      window2 = Window.create("window_handle2")
      window3 = Window.create("window_handle3")

      capybara_stub.browser.expects(:window_handle).returns("window_handle1")
      assert_equal window1, Window.current

      capybara_stub.browser.expects(:window_handle).returns("window_handle2")
      assert_equal window2, Window.current

      capybara_stub.browser.expects(:window_handle).returns("window_handle3")
      assert_equal window3, Window.current
    end
  end
end
