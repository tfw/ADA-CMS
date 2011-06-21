class Mutexer
  LIMIT = 5
  MUXES = []
  
  LIMIT.times {MUXES << Mutex.new}
  
  def self.reset
    for mutex in MUXES
      mutex.unlock if mutex.locked?
    end
  end

  def self.wait_for_mutex(n)
    mutex = Mutexer.available
    
    begin
      mutex = Mutexer.available
      sleep n if mutex.nil?
    end while mutex.nil?
    
    mutex
  end
  
  def self.available
    for mutex in MUXES
      available = mutex if not mutex.locked?
      break if available
    end
       
    # puts report
    available
  end
  
  def self.report
    txt = "["
    for mutex in MUXES 
      txt << "#{mutex.locked? ? 'locked' : 'unlocked' }"
      txt << "," unless mutex == MUXES.last
    end
    txt << "]"
    txt
  end
end