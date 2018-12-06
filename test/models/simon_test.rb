require 'test_helper'
require 'json'

class SimonTest < ActiveSupport::TestCase
  TEST_COUNT = 30

  test "test_simon_model_IO" do
    messages = Array[]
    dataset = Array[]

    i = 0
    TEST_COUNT.times do
      i+=1
      message = rand_str
      messages.push message
      data = Array(4)
      (rand 5).times {data.push rand_str}
      dataset.push data

      Simon.create(request: i, message: message, data: data.to_json)
    end

    i = 0
    TEST_COUNT.times do
      i+=1
      record = Simon.find_by request: i
      assert_equal messages[i-1], record.message
      data = JSON.parse record.data
      dataset[i-1].each_index do |j|
        assert_equal dataset[i-1][j], data[j]
      end
    end
  end

  test "test_request_in_simon_model_is_unique" do
    exception_raised = false
    begin
      Simon.create(request: 1, message: 'some_message', data: 'some_data')
      Simon.create(request: 1, message: 'some_message', data: 'some_data')
    rescue ActiveRecord::RecordNotUnique
      exception_raised = true
    end
    assert exception_raised
  end

  protected

  def rand_int
    rand(200)
  end

  def rand_str
    [*('A'..'Z'),*('a'..'z')].sample(rand(1..20).to_i).join
  end
end
