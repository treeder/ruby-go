
module Go
  class GoKernel
    def initialize(config)
      @config = config
      @executor = Concur::Executor.new_thread_pool_executor(@config.max_threads)
      @config.add_listener(@executor)
    end

    def executor
      @executor
    end
  end

  def self.gok
    @gok ||= GoKernel.new(Go.config)
  end

end

module ::Kernel
  def go(ch=nil, &blk)
    future = ::Go.gok.executor.execute(nil, ch, &blk)
    future
  end
end
