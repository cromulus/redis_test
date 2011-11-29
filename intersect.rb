require 'rubygems'
require 'thread_pool'
require './redistest.rb'
require 'redis'
r=Redis.new
rt=RedisTest.new
pool2 = ThreadPool.new(threads = 100)
r.smembers("userids").each{|n|
  pool2.execute(n) {|local| 
    puts local
    rt.do_intersection(local) 
  }
}
pool2.join
