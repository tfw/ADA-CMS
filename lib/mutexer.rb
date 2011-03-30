class Mutexer
  LIMIT = 10
  MUXES = []
  
  LIMIT.times {MUXES << Mutex.new}
  
  def self.reset
    for mutex in MUXES
      mutex.unlock if mutex.locked?
    end
  end
  
  def self.available
    for mutex in MUXES
      available = mutex if not mutex.locked?
      break if available
    end
    
    # available.lock if available          
    # puts "**** \n\n offering a mutex" if available          
    # puts "**** \n\n all mutexes taken" unless available          
    puts report
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