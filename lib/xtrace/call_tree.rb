module XTrace
  class CallTree
    attr_accessor :call_trace, :call_depth, :call_time, :call_total_elapsed, :call_delta_elapsed, 
                  :elapsed_time, :parent,
                  :calls

    def initialize(call_trace, call_depth, call_time, call_total_elapsed, call_delta_elapsed)
      @call_trace = call_trace.gsub(/\(.*\)/, '(...)')
      @call_depth = call_depth
      @call_time = call_time
      @call_total_elapsed = call_total_elapsed
      @call_delta_elapsed = call_delta_elapsed
      @calls = []
      @elapsed_time = call_delta_elapsed
    end

    def call_stack
      if parent.nil?
        [@call_trace]
      else
        [parent.call_stack, @call_trace].flatten
      end
    end

    def call_path(delim = ' --> ')
      call_stack.join(delim)
    end

    def add_time(elapsed_time)
      @elapsed_time += elapsed_time
      @parent.add_time(elapsed_time) unless @parent.nil?
    end

    def <<(call_tree)
      add_time(call_tree.elapsed_time)
      call_tree.parent = self
      @calls << call_tree
    end

    def output
      #if @calls.length > 1
      if @elapsed_time > 1.0
        prefix = ' ' * (@call_depth*2)
        puts "#{prefix}Call: #{@call_trace}"
        #puts "#{prefix}\tPath: \n\t > #{self.call_path("\n\t > ")}"
        puts "#{prefix}\tSubcalls:#{@calls.length}"
        puts "#{prefix}\tTime Elapsed: #{@elapsed_time}"
      end
      @calls.each do |call|
        call.output
      end
    end
  end
end

