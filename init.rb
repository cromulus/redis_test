require 'rubygems'
require 'thread_pool/lib/thread_pool.rb'
require 'redistest.rb'

r=Redis.new
r.flushall
rt=RedisTest.new
pool = ThreadPool.new(threads = 10)
(1...1000).each{|n|
  pool.execute(n) {|local| 
    puts local
    rt.populate_user_fans_set(local) 
  }
}
pool.join