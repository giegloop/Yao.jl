using Compat
using Compat.Test
using Yao
using Yao.Blocks
using Yao.Blocks: PutBlock

@testset "apply!" begin
    nbit = 6
    Reg = rand_state(nbit)

    pb = PutBlock{nbit}(X, (3,))
    rb = repeat(nbit, X, (3,))
    @test apply!(copy(Reg), pb) == apply!(copy(Reg), rb)

    Cb = control(nbit, (3,), 5=>X)
    pb = PutBlock{nbit}(CNOT, (3, 5))
    @test apply!(copy(Reg), Cb) == apply!(copy(Reg), pb)
end

@testset "dispatch!" begin
    nbit = 6
    pb = PutBlock{nbit}(rot(CNOT, 0.5), (3, 4))
    dispatch!(pb, 0.1)
    @test parameters(pb) == [0.1]
    dispatch!(+, pb, 0.1)
    @test parameters(pb) == [0.2]
    @test addrs(pb) == (3,4)
    @test usedbits(pb) == [3,4]
    @test blocks(copy(pb))[] === pb.block
    @test hash(copy(pb)) != hash(pb)
    @test copy(pb) == pb
    println(pb)
end

