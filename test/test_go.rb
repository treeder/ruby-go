gem 'test-unit'
require 'test/unit'
require_relative '../lib/go'

class TestGo < Test::Unit::TestCase

  def test_go

    Go.config.max_threads = 10

    3.times do |i|
      go do
        puts "#{i} sleeping..."
        sleep 1
        puts "#{i} awoke"
      end
      puts "#{i} done "
    end

    ch = Go::Channel.new
    times = 10
    times.times do |i|
      go do
        #puts "hello channel #{i}"
        sleep 1
        # push to channel
        ch << "hello, I am # #{i}"
      end
    end

    puts "waiting on channel..."
    i = 0
    ch.each do |x|
      puts "Got: #{x}"
      i += 1
    end
    assert_equal times, i

    # Pass different objects back
    ch = Go::Channel.new
    times = 10
    errmod = 5
    times.times do |i|
      go do
        begin
          raise "Error yo!" if i % errmod == 0
          puts "hello channel #{i}"
          sleep 1
          # push to channel
          ch << "pushed #{i} to channel"
        rescue => ex
          ch << ex
        end
      end
    end

    go do
      # wait for a bit, then close channel
      sleep 10
      ch.close
    end

    puts "waiting on channel..."
    i = 0
    errs = 0
    ch.each do |x|
      puts "Got #{x} from channel"
      i += 1
      case x
        when String
          puts "Is String"
        when Exception
          puts "Is Exception!"
          errs += 1
        when nil
          puts "got nil, breaking"
          break
        else
          puts "Is something else"
      end
    end
    assert_equal times, i
    assert_equal times / errmod, errs
    puts 'donezo'

  end


end



