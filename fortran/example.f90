program example

   use sandwich_solution

   implicit none

   integer, parameter :: dp = kind(0.0d0)
   integer :: i
   real(dp), dimension(3) :: E = [500.0d0, 100.0d0, 500.0d0]
   real(dp), dimension(2) :: p = [3.0d0, 2.0d0/5.0d0]
   real(dp) :: Q = -1.0d-2
   real(dp) :: M = -5.0d-2
   real(dp), dimension(3) :: h = [0.25d0, 0.5d0, 0.25d0]
   real(dp), dimension(3) :: nu = [0.3d0, 0.25d0, 0.3d0]
   real(dp) :: l = 5.0d0
   real(dp), dimension(3, 19) :: C = 0.0d0
   real(dp) :: x, y

   ! Example values for x, y
   x = l/2.0d0
   y = h(2)/2.0d0

   if (y < 0.0d0) then
      i = 1
   elseif (y > h(2)) then
      i = 3
   else
      i = 2
   end if

   ! Compute the C matrix
   C = computeC(E, nu, l, h, Q, M, p)

   print *, "(x, y) = (", x, ", ", y, ")"
   print *, "layer = ", i
   print *, "u_{1} = ", u1(C, x, y, i, E, nu)
   print *, "u_{2} = ", u2(C, x, y, i, E, nu)
   print *, "Stress_{11} = ", stress11(C, x, y, i)
   print *, "Stress_{22} = ", stress22(C, x, y, i)
   print *, "Stress_{12} = ", stress12(C, x, y, i)

end program example
