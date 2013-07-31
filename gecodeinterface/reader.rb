#!/usr/bin/ruby
#
# Reads the logging format generated by the debug log method and generates/runs a problem
#
#
lastfile = nil
ARGF.each do |line|
  if lastfile then
    if lastfile != ARGF.filename then
      puts "X"
    end
  end
  lastfile = ARGF.filename

  case line
  when /Creating VersionProblem inst\# (\d+) with (\d+) packages, (\d+) stats, (\d+) debug/
    instance, pkg_count, stats, debug = $1,$2.to_i,$3.to_i,($4 == '0' ? false : true)
    puts "NEW #{instance} #{pkg_count}"
  when /DepSelector inst\# (\d+) - Adding package id (\d+)\/(\d+): min = (-?\d+), max = (-?\d+), current version (-?\d+)/
    instance, pkg_id, pkg_count, min, max, cur = [$1,$2,$3,$4,$5,$6].map { |x| x.to_i }
    puts "P #{min} #{max} #{cur}"
  when /DepSelector inst\# (\d+) - Adding VC for (\d+) @ (\d+) depPkg\s+(\d+)\s+\[\s*(\d+),\s*(\d+)\s+\]/
    instance, pkg_id, pkg_ver, depPkg_id, constraint_min, constraint_max = [$1, $2, $3, $4, $5, $6].map { |x| x.to_i }
    puts "C #{pkg_id} #{pkg_ver} #{depPkg_id} #{constraint_min} #{constraint_max}"
  when /DepSelector inst\# (\d+) - Marking Package Suspicious (\d+)/
    instance, pkg_id = $1.to_i, $2.to_i
    puts "S #{pkg_id}"
  when /DepSelector inst\# (\d+) - Marking Package Required (\d+)/
    instance, pkg_id = $1.to_i, $2.to_i
    puts "R #{pkg_id}"
  when /DepSelector inst\# (\d+) - Marking Package Preferred Latest (\d+) weight (\d+)/
    instance, pkg_id, weight = [$1, $2, $3].map { |x| x.to_i }
    puts "L #{pkg_id} #{weight}"
  else
    # puts "unmatched"
  end
end
puts "X"




