class Command

  def initialize
    @exec_data = {}
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
      params = cmd[:params]

      if not @exec_data.empty?
        params.merge!(@exec_data)
      end

      # Hash expected from Proc execution
      @exec_data = cmd[:command].call(params)
    end
  end

end