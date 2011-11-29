require 'rubygems'
require './thread_pool/lib/thread_pool.rb'
require './redistest.rb'

r=Redis.new
r.flushall
rt=RedisTest.new
pool = ThreadPool.new(threads = 10)
(1...1000).each{|n|
  pool.execute(n) {|local| rt.populate_user_fans_set(local) }
}
pool.join

# (100...110).each{|u|
#   rt.populate_user_fans_set(u)
# }
# (100...110).each{ |u| rt.do_intersection(u)  }
# r.zrange("z_inter:100",0,r.zcard("z_inter:100"),true)
# 
