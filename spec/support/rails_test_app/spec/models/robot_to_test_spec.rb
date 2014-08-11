require 'rails_helper'

describe RobotToTest do
  let(:robot_to_test) do
    RobotToTest.new('Emiliano', { planets: ['Mars', Human.home] })
  end

  it '#robot_name' do
    expect(robot_to_test.robot_name('Emiliano')).to eq('Robot_Emiliano')
  end

  it '#cv' do
    expect(robot_to_test.cv).to eq({ planets: ['Mars', 'Earth'] })
  end

  it '#nested_fun_objects' do
    expect(robot_to_test.nested_fun_objects([[:array, :in, :array], { hash: { in_hash: { in: ['array'] } } }])).to eq('It was fun')
  end

  it '#prefix' do
    expect(RobotToTest.prefix).to eq('Robot')
  end
end

describe Human do
  let(:human) do
    Human.new
  end

  it '#home' do
    expect(Human.home).to eq('Earth')
  end
end
