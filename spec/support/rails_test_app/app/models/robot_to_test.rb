class RobotToTest
  def initialize(human_name, _cv)
    @name = robot_name(human_name)
  end

  def robot_name(human_name)
    "#{self.class.prefix}_#{human_name}"
  end

  def cv
    { planets: planets }
  end

  def nested_fun_objects(_fun_objects)
    'It was fun'
  end

  def self.prefix
    'Robot'
  end

  private

  def planets
    ['Mars', Human.home]
  end

  def fun_objects
    [%i[array in array], { hash: nested_hash }]
  end

  def nested_hash
    { in_hash: { in: array } }
  end

  def array
    %w[array]
  end
end

class Human
  def initialize
    human_name = 'Emiliano'
  end

  def self.home
    'Earth'
  end
end
