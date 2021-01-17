class Command

  def initialize
    @exec_data = {}
    @params = {}
    @commands = []
  end

  # @param [hash] params
  # @param [Proc] command
  def add params: {}, &command
    @commands << {
      :params => params,
      :command => command
    }
  end

  def execute
    @commands.each do |cmd|
      @params.merge!(cmd[:params])

      if not @exec_data.nil? and @exec_data.is_a?(Hash)
        @params.merge!(@exec_data)
      end

      # Hash expected from Proc execution
      @exec_data = cmd[:command].call(@params)
    end

    return self
  end

  def data
    @exec_data[:response]
  end

end