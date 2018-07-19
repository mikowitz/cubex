r=->y{y.split.map{|x|[*x.chars]}}

G=r['UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR']
# o=r[gets]
o = r['RU LF UB DR DL BL UL FU BD RF BR FD LDF LBD FUL RFD UFR RDB UBL RBU']

x=[];
[
  [%w{U UU UUU L LL LLL D DD DDD},0],
  # [%w{FDFFF RFDFFFRRR D DD DDD},12],
  # [%w{DDDRRRDRDFDDDFFF DLDDDLLLDDDFFFDF D DD DDD},8],
  # [%w{DFLDLLLDDDFFF RDUUUFDUUULDUUUBDUUU D DD DDD},4],
  # [%w{LDDDRRRDLLLDDDRD RRRDLDDDRDLLLDDD LFFFLLLFLFFFLLLF D DD DDD},16]
].map { |q,y|
  x+=[*y..y+3]
  3.times {
    q.map { |e|
      q |= [e.tr('LFRB','FRBL')]
    }
  }
  puts x.inspect
  w= ->u {x.count{ |t| u[t] != G[t] }}
  s=w[o]
  # puts "=======> #{s.inspect}"
  # puts G.inspect
  # puts o.inspect
  # puts "==================================================="
  # (
    c=(0..rand(12)).map{q.sample}*''
    puts "  ===="
    puts "   #{c.inspect}"
    puts "  ===="
    z=o
    puts z.inspect
    c.chars{ |m|
      puts "=== #{m} ==="
      x = [61, 36, 39, 42, 58, 48, 51, 54, 34, 46, 63, 66, 79, 72, 75, 86, 71, 82, 87, 90, 33, 36, 64, 42, 45, 48, 67, 54, 57, 60, 52, 40, 69, 92, 73, 78, 81, 84, 77, 88, 33, 36, 39, 66, 45, 48, 51, 60, 57, 42, 63, 54, 69, 72, 89, 76, 81, 80, 85, 90, 33, 57, 39, 42, 45, 63, 51, 54, 48, 60, 36, 66, 83, 70, 75, 78, 91, 84, 87, 74, 36, 39, 42, 33, 45, 48, 51, 54, 57, 60, 63, 66, 72, 75, 78, 69, 81, 84, 87, 90, 33, 36, 39, 42, 54, 45, 48, 51, 57, 60, 63, 66, 69, 72, 75, 78, 84, 87, 90, 81]
        # "=$'*:036\".?BOHKVGRWZ!$@*-0C69<4(E\\INQTMX!$'B-03<9*?6EHYLQPUZ!9'*-?360<$BSFKN[TWJ$'*!-0369<?BHKNEQTWZ!$'*6-039<?BEHKNTWZQ"
      b = x[20*('FBLRUD'=~/#{m}/),20]
      puts b.inspect
      puts b.map{|e| e/3-11 }.zip(b.map{|e| e%3}).inspect
      z = b.map{ |e|
        z[e/3-11].rotate e%3
      }
    }
    t=w[z]
    (
      # c.chars { |e|
      #   $> << e << "1 "
      # }
      o=z
      s=t
    ) if s > t
  # ) until s < 1
}
