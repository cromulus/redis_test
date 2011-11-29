require 'rubygems'
require 'thread_pool/lib/thread_pool.rb'
require 'redistest.rb'

rt=RedisTest.new
pool2 = ThreadPool.new(threads = 100)
(1...1000).each{|n|
  pool2.execute(n) {|local| rt.do_intersection(local) }
}
pool2.join
