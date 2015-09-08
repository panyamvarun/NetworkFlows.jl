using NetworkFlows
using Base.Test

## Test link.jl ##
import NetworkFlows.zero_to_one!
@test zero_to_one!([(0,1),(1,2)]) == [(1,2),(2,3)]
@test zero_to_one!([(3,1),(1,2)]) != [(3,1),(1,2)]
@test zero_to_one!([(0,1,1.),(1,2,2.)]) == [(1,2,1.),(2,3,2.)]
@test zero_to_one!([(3,1,0.),(1,2,-2.1)]) != [(3,1,0.),(1,2,-2.1)]

import NetworkFlows.Arc, NetworkFlows.ghostArc, NetworkFlows.simpleArc
@test Arc(0,1,0.).sym == ghostArc(1).sym
@test Arc(0,1,0.).head == ghostArc(1).head
@test Arc(0,1,0.).cap == ghostArc(1).cap
@test Arc(0,2,1.).sym == simpleArc(2).sym
@test Arc(0,2,1.).head == simpleArc(2).head
@test Arc(0,2,1.).cap == simpleArc(2).cap

## Test network.jl
import NetworkFlows.Network, NetworkFlows.findArc
g1 = Network(1,2,[1,2,2],[Arc(0,2,1.)])
g2 = Network(2,1,[1,2,2],[simpleArc(2)])
@test g1.source == g2.target
@test g2.source == g1.target
@test g1.tails == g2.tails
@test length(g1.links) == length(g2.links)
@test findArc(g1,1,2) == findArc(g2,1,2)

## Test io.jl
import NetworkFlows.print
edges_list = [(0,1,5.),(0,2,7.),(0,5,1.75),(0,6,1.3),(1,3,2.),(2,1,1.),
  (2,3,11.),(2,4,8.),(3,5,6.),(4,5,3.),(6,5,1.25)]
zero_to_one!(edges_list)
g3 = Network(edges_list, true, 1, 6)
print(g3)

## Test search.jl
import NetworkFlows.bfs
println(bfs(g3,:Path))

## Test flow.jl
import NetworkFlows.edmondsKarp, NetworkFlows.connectivity
import NetworkFlows.kishimoto
@test edmondsKarp(g3)[1] == 12
@test connectivity(g3) == 4
@test kishimoto(g3,3)[1] == 3

## Test cut.jl
