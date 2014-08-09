require 'rails_helper'

describe RobotToTest do
  let(:robot_to_test) do
    RobotToTest.new
  end

  it '#some_helping_method' do
    expect(robot_to_test.some_helping_method).to eq('hello')
  end

  it '#test_method_return_as_arg' do
    expect(robot_to_test.test_method_return_as_arg('hello')).to eq('hello')
  end
end
