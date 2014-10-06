require 'unit_helper'

module AePageObjects
  class WaiterTest < Test::Unit::TestCase
    def test_wait_for
      Capybara.expects(:default_wait_time).returns(5)

      block_calls = sequence('calls')
      Capybara.expects(:using_wait_time).in_sequence(block_calls).with(0).yields.returns(false)
      Capybara.expects(:using_wait_time).in_sequence(block_calls).with(0).yields.returns(true)

      block = mock
      block.expects(:called).times(2)
      result = Waiter.wait_for do
        block.called
      end

      assert_equal true, result
    end

    def test_wait_for_bang
      Capybara.stubs(:default_wait_time).returns(1)

      my_obj = Object.new

      result = Waiter.wait_for! do
        my_obj
      end

      assert_equal my_obj, result
    end

    def test_wait_for_bang__exception
      Capybara.stubs(:default_wait_time).returns(1)

      assert_raises WaitTimeoutError do
        Waiter.wait_for! do
          false
        end
      end
    end

    def test_wait_for__timeout
      Capybara.stubs(:default_wait_time).returns(1)

      result = Waiter.wait_for do
        false
      end

      assert_equal false, result
    end

    def test_wait_for__set_wait_time
      Capybara.expects(:default_wait_time).never

      block_calls = sequence('calls')
      time_calls  = sequence('time')

      10.times {|n| Time.expects(:now).in_sequence(time_calls).returns(n)}
      9.times { Capybara.expects(:using_wait_time).in_sequence(block_calls).with(0).yields.returns(false) }
      Capybara.expects(:using_wait_time).in_sequence(block_calls).with(0).yields.returns(true)

      block = mock
      block.expects(:called).times(10)
      result = Waiter.wait_for(10) do
        block.called
      end

      assert_equal true, result
    end

    def test_wait_for__set_wait_time_time_out
      Capybara.expects(:default_wait_time).never

      block_calls = sequence('calls')
      time_calls  = sequence('time')

      11.times { |n| Time.expects(:now).in_sequence(time_calls).returns(n) }
      10.times { Capybara.expects(:using_wait_time).in_sequence(block_calls).with(0).yields.returns(false) }

      block = mock
      block.expects(:called).times(10)
      result = Waiter.wait_for(10) do
        block.called
      end

      assert_equal false, result
    end
  end
end
