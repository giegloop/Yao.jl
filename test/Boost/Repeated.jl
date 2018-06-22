using Compat.Test
using Yao
using Yao.Intrinsics
using Yao.Blocks
using Yao.Boost

@testset "XYZ" begin
    reg1 = rand_state(3)
    reg2 = rand_state(3, 2)
    for G in [X, Y, Z]
        rb = RepeatedBlock{3}(G, (1,2))
        res = kron(kron(mat(I2), mat(G)), mat(G))
        @test mat(rb) ≈ res
        @test apply!(copy(reg1), rb) |> statevec ≈ res*statevec(reg1)
        @test apply!(copy(reg2), rb) |> statevec ≈ res*statevec(reg2)

        rb = RepeatedBlock{3}(G, (1,))
        res = kron(kron(mat(I2), mat(I2)), mat(G))
        @test mat(rb) ≈ res
        @test apply!(copy(reg1), rb) |> statevec ≈ res*statevec(reg1)
        @test apply!(copy(reg2), rb) |> statevec ≈ res*statevec(reg2)
    end
end

@testset "U1" begin
    reg1 = rand_state(3)
    reg2 = rand_state(3, 2)
    for G in [H, rot(X, 0.5), rot(Z, 0.5), I2]
        rb = RepeatedBlock{3}(G, (1,))
        res = kron(kron(mat(I2), mat(I2)), mat(G))
        @test mat(rb) ≈ res
        @test apply!(copy(reg1), rb) |> statevec ≈ res*statevec(reg1)
        @test apply!(copy(reg2), rb) |> statevec ≈ res*statevec(reg2)
    end
end

@testset "Un" begin
    reg1 = rand_state(5)
    reg2 = rand_state(5, 2)
    for G in [H, rot(X, 0.5), rot(Z, 0.5), I2]
        rb = put(control(2, (1,), 2=>G), 5, 3)
        res = mat(control(5, (5,), 3=>G))
        @test mat(rb) ≈ res
        @test apply!(copy(reg1), rb) |> statevec ≈ res*statevec(reg1)
        @test apply!(copy(reg2), rb) |> statevec ≈ res*statevec(reg2)
    end
    b1 = put(control(3, (1, 3), (0, 1), 2=>rot(X, 0.3)), 5, 3, 1)
    b2 = control(5, (5, 1), (0, 1), 3=>rot(X, 0.3))
    mat(b1) == mat(b2)
    apply!(copy(reg1), b1) == apply!(copy(reg1), mat(b2))
    apply!(copy(reg2), b1) == apply!(copy(reg2), mat(b2))
end

