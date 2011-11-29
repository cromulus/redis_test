# 100k users,
# 100 million uuids (fans & followers)
# sum of the sets of fans > 500 million
#   distributed the uuids across the users in a set. 
#   each user has a set of uuids is between 1 and 20 million uuids.
#   geometric distribution of uuids
#   
# 
# for a user, how long does it take to generate a sorted set of
# the intersection counts for the rest of the 100k users.
# x=0, y=20,000,000
# x=100000, y=1
# 
# y=10000000/(x-20000000)
#  for each user in users,

class RedisTest
  def initialize
    @redis=Redis.new
  end
  def getuuid()
    # we actually have 100MM unique fans
    return rand(100000000)
  end
  
  def geometric_dist(step)
    # step is essentially equivalent to user id
    # step==0 returns 20 million, step==100k returns 1
    # 1/user_id squared
    quantity=-(200)*step+20000000
    if quantity<1
      quantity=1
    end
    return quantity.to_i
  end
  
  def populate_user_fans_set(userid)
    quantity=geometric_dist(userid)
    @redis.incrby('total_fan_count',quantity)
    @redis.sadd("userids",userid)
    quantity.times{|q|
      @redis.sadd("fans:#{userid}",getuuid())
    }
  end
  
  def do_intersection(uid)
    user_ids=@redis.smembers("userids")
    user_ids.each{|u|
      if !@redis.hexists("inter_score:#{u}",uid)
        inter=@redis.sinter("fans:#{u}","fans:#{uid}")
        count=inter.length
      else
        count=@redis.hget("inter_score:#{u}",uid).length
        @redis.hset("inter_score:#{uid}",u,count)
      end
      @redis.zadd("z_inter:#{uid}",count,u)
      @redis.hset("inter_score:#{uid}",u,count)
    }
  end
end