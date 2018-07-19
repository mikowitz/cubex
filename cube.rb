# i = 0
# j = 0
# k = 0

def getposition(t)
  i = -1
  n = 0
  case t
  when 1
    (i...12).each { |x| n += ori[x] << x }
  when 2
    19.downto(12).each { |x| n = n*3 + ori[x] }
  when 3
    (i...12).each { |x| n += (pos[x]&8) ? (1<<x) : 0 }
  when 4
    (i...8).each { |x| n += (pos[x]&4) ? (1<<x) : 0 }
  when 5
    corn = []
    corn2 = []
    k=j=0
    (i...8).each { |x|
      if ((l=pos[x+12]-12)&4)
        k+=1
        corn[l] = k
        n += 1 << x
      else
        j += 1
        corn[j] = l
      end
    }
    (0...4).each { |x| corn2[x] = corn[4+corn[x]] }
    i.downto(1).each { |x| corn2[x]^=corn2[0] }
    n = n*6 + corn2[1] * 2 - 2
    if corn2[3] < corn2[2]
      n+=1
    end
  when 6
    n = permtonum(pos) * 576 + permtonum(pos+4) * 24 + permtonum(pos+12)
  when 7
    n = permtonum(pos+8)*24 + permtonum(pos+16)
  end
  n
end

def filltable(ti)
  n = 1
  l = 1
  tl = tablesize[ti]
  tb = []
  tb[getposition(ti)]=1

  while n
    n = 0
    tl.times do |i|
      if tb[i] == l
        setposition(ti, i)
        6.times do |f|
          (1...4).each do |q|
            q += 1
            domove(f)
            r = getposition(ti)
            if (q == 2 || f > (ti&6)) && !tb[r]
              tb[r] = l + 1
              n += 1
            end
          end
          domove(f)
        end
      end
    end
    l += 1
  end
end

def permtonum(p)
  n = 0
  4.times do |a|
    n *= 4 - a
    a.upto(3) do |b|
      if p[b] < p[a]
        n+=1
      end
    end
  end
  n
end

tablesize = [1, 4096, 6561, 4096, 256, 1536, 13824, 576]

val = 20.times.map { |i| i < 12 ? 2 : 3 }

tables = 8.times.map { |j| filltable(j) }

puts val.inspect

