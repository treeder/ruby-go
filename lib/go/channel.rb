module Go
  class Channel
    attr_reader :closed

    def initialize
      @queue = Queue.new
    end

    def <<(ob)
      @queue << ob
    end

    def shift
      begin
        @queue.shift
      rescue Exception => ex
        puts ex.class.name
        p ex
        puts ex.message
        if ex.class.name == "fatal" && ex.message.include?("deadlock")
          close()
          return Go::Exit
        end
        raise ex
      end
    end

    def each(&blk)
      while true do
        puts "Closed? #{@closed}"
        break if @closed
        x = shift
        break if x == Go::Exit
        yield x
      end
    end

    # close the channel
    def close
      puts 'closing channel'
      @closed = true
      self << Go::Exit
    end
  end

  # Just for exiting a channel
  class Exit

  end

end
