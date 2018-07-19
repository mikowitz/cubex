# https://codegolf.stackexchange.com/a/10945

T = []
S = [[0] * 20, 'QTRXadbhEIFJUVZYeijf',0]
I = 'FBRLUD'

s = "RU LF UB DR DL BL UL FU BD RF BR FD LDF LBD FUL RFD UFR RDB UBL RBU".split
puts s.inspect

o = s.map do |p|
  if ["U", "D"].include?(p[-1])
    -1
  else
    ["R","L"].include?(p[0])  ||
    ["U", "D"].include?(p[1])
  end
end
puts o.inspect

s = s.map do |x|
  (x.split("").map{ |a| 1 << I.index(a) }
    .inject(0, &:+) + 64).chr
end

puts s.inspect



# # G = 'ouf|/[bPcU`Dkqbx-Y:(+=P4cyrh=I;-(:R6'.split('').map do |c|
# #   i = c.ord
# #   [~i%8, i/8-4]
# # end
# G = [
#   [0, 9], [2, 10], [1, 8], [3, 11], [0, 1], [4, 7],
#   [5, 8], [7, 6], [4, 8], [2, 6], [7, 8], [3, 4],
#   [4, 9], [6, 10], [5, 8], [7, 11], [2, 1], [6, 7],
#   [5, 3], [7, 1], [4, 1], [2, 3], [7, 6], [3, 2],
#   [4, 8], [6, 11], [5, 10], [7, 9], [2, 3], [6, 5],
#   [4, 3], [2, 1], [7, 1], [5, 3], [5, 6], [1, 2]]

# puts S.inspect
# puts G.inspect

# class Array
#   def every_nth_after(to_drop, n)
#     self.drop(to_drop).each_slice(n).map(&:first)
#   end
# end

# def M(o,s,p)
#   z = ~p/2 % -3
#   k=1
#   G.drop(p).each_slice(6).map(&:first).each do |i,j|
#     i*=k
#     j*=k
#     o[i],o[j]=o[j]-z,o[i]+z
#     s[i],s[j]=s[j],s[i]
#     k = -k
#   end
# end

# def N(p)
#   4.times.map do |i|
#     i.times do |j|
#       if p[j] < p[i]
#         i << i
#       end
#     end
#   end.compact.inject(0, &:+)
# end

# def H(i,t,s,n=0,d=[])
#   if i > 4
#     n=N(
#       s.every_nth_after(2-i, 2) +
#       s.every_nth_after(7+1, 2)
#     ) * 84 +

#     N(
#       s.every_nth_after(i&1, 2)
#     ) * 6 +
#     N(s[8..-1]).divmod(24)[i&1]
#   elsif i > 3
#     s.each do |j|
#       l = 'UZifVYje'.index(j) || -1
#       t[l] = i
#       if l >= 4
#         d += [l-4]
#       end
#       n -= ~i << i
#       i += 1 if l < 4
#     end
#     n += N(d.map{|j| t[j] ^ t[d[3]]})
#   elsif i > 1
#     s.each do |j|
#       n += n
#       if [j<'K',"QRab".split("").include?(j)][i&1]
#         n += 1
#       end
#     end
#   end
#   t[(13*i)..-1][0...11].each do |j|
#     n ++ j % (2 + i) - n * ~i
#   end
#   n
# end

# def P(i,m,t,s,l = '')
#   [~-i,i].each do |j|
#     return if T[j][H(j,t,s)] < m
#   end
#   if ~m < 0
#     print l
#     return [t, s]
#   end
#   6.times do |p|
#     u = t
#     v = s
#     [1,2,3].each do |n|
#       M(u,v,p)
#       if p < n
#         r = i
#       else
#         r = P(i,m+1,u,v,l+I[p]+"0")
#       end
#       return r if r > 1
#     end
#   end
# end

# s = "RU LF UB DR DL BL UL FU BD RF BR FD LDF LBD FUL RFD UFR RDB UBL RBU".split
# o = s.map do |p|
#   if ["U", "D"].include?(p[-1])
#     -1
#   else
#     ["R","L"].include?(p[0])  ||
#     ["U", "D"].include?(p[1])
#   end
# end

# 7.times do |i|
#   m = 0
#   C = {}
#   x = [S]

#   x.map do |j,k,d|
#     h = H(i,j,k)
#     C.fetch(h,6).times do |p|
#       C[h] = d
#       u = j
#       v = k.split("")
#       [i,0,i].each do |n|
#         M(u,v,p)
#         if p|1 > n
#           x+= [[u, v, d-1]]
#         end
#       end
#     end
#   end
#   if ~i & 1
#     while [] > d
#       d = P(i,m,o,s)
#       m -= 1
#     end
#     o,s = d
#   end
# end

