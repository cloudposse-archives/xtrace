require 'iconv'

module XTrace
  class Parser

    attr_accessor :ic, :fh, :total_calls, :call_trees, :call_cache
    #
    #    0.0001     114976   -> {main}() /var/opt/content-8000/live/www/index.php:0
    #    0.0003     115392     -> include_once(/var/opt/content-8000/live/www/LocalConfig.php) /var/opt/content-8000/live/www/index.php:10
    #    0.0004     116112       -> dirname('/var/opt/content-8000/live/www/LocalConfig.php') /var/opt/content-8000/live/www/LocalConfig.php:15
    #                             >=> '/var/opt/content-8000/live/www'

    def initialize(fh = STDIN)
      @ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      @fh = fh
      @total_calls = 0
      @call_trees = []
      @call_tree = nil
      @call_cache = {}
    end

    def execute
      last_total_elapsed = 0.000
      return_value = nil
      while(line = @fh.gets)
        line = @ic.iconv(line)
        if line =~ /^\s+([\d.]+)\s+(\d+)   ( *)-> (.*)$/
          total_elapsed = $1.to_f
          time = $2.to_i
          depth = $3.to_s.length/2
          trace = $4.to_s

          delta_elapsed = total_elapsed - last_total_elapsed
          @total_calls += 1
          last_total_elapsed = total_elapsed

          call_tree = CallTree.new(trace, depth, time, total_elapsed, delta_elapsed)

          if depth == 0
            @call_tree = call_tree
            @call_trees << call_tree
          else
            #puts "depth:#{depth} parent:#{@call_cache[depth-1].call_trace} call:#{trace}"
            @call_cache[depth-1] << call_tree
          end      

          # Always set the last call_tree at a given depth
          @call_cache[depth] = call_tree

          if delta_elapsed > 0
            #puts "[#{total_calls}] [#{depth}] [#{time}] [#{total_elapsed}] [#{delta_elapsed}] [#{trace}]"
          end
        else
          return_value = line
        end
      end
    end

    def output
      @call_trees.each do |call_tree|
        call_tree.output
      end
    end
  end
end

parser = XTrace::Parser.new(STDIN)
parser.execute
parser.output
