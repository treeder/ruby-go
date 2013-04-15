module Go
  class Channel
    attr_reader :closed, :msg_counter
    attr_accessor :options

    def initialize(options={})
      @options = options
      @msg_counter = 0
      @queue = Queue.new
    end

    def <<(ob)
      @queue << ob
    end

    def shift
      begin
        @msg_counter += 1
        if @options[:close_after] && @msg_counter >= @options[:close_after]
          close()
        end
        @queue.shift
      rescue Exception => ex
        Go.logger.debug "#{ex.class.name}: #{ex.message}"
        if (ex.message.include?("deadlock") || ex.message.include?("Deadlock")) # ruby 2.0 uses Deadlock, capitalized
          close()
          return Go::Exit
        end
        raise ex
      end
    end

    def each(&blk)
      while true do
        break if @closed
        x = shift
        break if x == Go::Exit
        yield x
      end
    end

    # close the channel
    def close
      @closed = true
      self << Go::Exit
    end
  end

  # Just for exiting a channel
  class Exit

  end

end
