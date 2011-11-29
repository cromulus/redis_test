require 'rubygems'
require './redistest.rb'
require 'parallel'
r=Redis.new
r.flushall

count=*(1...100000)
Parallel.map(count,:in_processes=>50){|n|
  rt=RedisTest.new
  rt.populate_user_fans_set(n) 
}
