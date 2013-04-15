# Go - A concurrency library for Ruby inspired by Go (golang).

## Getting Started

Install gem:

```
gem install go
```

## Usage

### Basic

```ruby
require 'go'

# set max threads (optional)
Go.config.max_threads = 10

# fire off blocks using go
100.times do |i|
  go do
    puts "hello #{i}"
    sleep 1
    puts "#{i} awoke"
    puts "hi there"
  end
  puts "done #{i}"
end
```

### Use channels to communicate

```ruby
require 'go'

# Use channels to communicate
ch = Go::Channel.new
20.times do |i|
  go do
    puts "hello channel #{i} #{ch}"
    sleep 2
    # push to channel
    ch << "pushed #{i} to channel"
  end
end

# Read from channel
ch.each do |x|
  puts "Got #{x} from channel"
end
```

### Catching exceptions and checking for different return types on the channel

```ruby
require 'go'

# Use channels to communicate
ch = Go::Channel.new
20.times do |i|
  go do
    begin
      puts "hello channel #{i}"
      ch << "pushed #{i} to channel"
    rescue => ex
      ch << ex
    end
  end
end

# Read from channel
ch.each do |m|
  puts "Got #{m} from channel"
  case m
    when String
      puts m
    when Exception
      puts "ERROR!!! #{m}"
    else
      puts "Something else: #{m}"
  end
end
```

### Closing the channel

You can close the channel with the close() method which will stop all the listeners on the channel.

```ruby
ch.close()
```

#### Automatically closing the channel after x messages

When making the channel, pass in :close_after parameter:

```ruby
ch = Go::Channel.new(:close_after=>100)
```

