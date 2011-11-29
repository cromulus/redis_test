require 'rubygems'
require './thread_pool/lib/thread_pool'
require './redistest.rb'
require 'redis'
require 'parallel'
r=Redis.new
Parallel.map(r.smembers("userids"),:in_processes=>16){|n|
  rt=RedisTest.new
  rt.do_intersection(n) 
}
