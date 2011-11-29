require 'rubygems'
require './thread_pool/lib/thread_pool'
require './redistest.rb'

r=Redis.new
r.flushall
rt=RedisTest.new
(1...100000).each{|n|

    puts n
    rt.populate_user_fans_set(n) 
  
}