program example

   use sandwich_solution
   use kind_parameter

   implicit none

   real(dp), dimension(3) :: E = [1.0d+00, 2.0d+00, 3.0d+00]
   real(dp), dimension(2) :: q = [1.0d+00, 2.0d+00]
   real(dp) :: QQ = 3.0d+00
   real(dp) :: M = 2.0d+00
   real(dp), dimension(3) :: h = [1.0d+00, 2.0d+00, 3.0d+00]
   real(dp), dimension(3) :: nu = [0.3d+00, 0.3d+00, 0.2d+00]
   real(dp) :: l = 5.0d+00
   real(dp), dimension(3, 19) :: C
   real(dp) :: x, y
   integer :: i

   ! Example values for x, y, and i
   x = 1.0d+00
   y = 1.0d+00
   i = 1

   ! Initialize or compute the C matrix here
   C = compute_C(E, nu, l, h, QQ, M, q)

   print *, "u_{x} = ", u1(C, x, y, i, E, nu)
   print *, "u_{y} = ", u2(C, x, y, i, E, nu)
   print *, "Stress_{xx} = ", stress11(C, x, y, i)
   print *, "Stress_{yy} = ", stress22(C, x, y, i)
   print *, "Stress_{xy} = ", stress12(C, x, y, i)

end program example
