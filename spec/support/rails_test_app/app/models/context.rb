class Context
  def initialize(options)
    @options = options || {}
  end

  def user
    @options[:user]
  end
end
