!-------------------------------------------------------------------
!
!  This is the external subprogram for derivative of free energy
!
!  The function is a pure function
!
!  Modified   :
!		 11 August 2023
!
!------------------------------------------------------------------



pure function Deriv_free_energy ( A_, con_)
  implicit none

  integer ( 4 ), parameter :: Nx = 64
  integer ( 4 ), parameter :: Ny = 64
  real ( 8 ), dimension ( Nx, Ny ) :: deriv_free_energy
  real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: con_
  real ( 8 ), intent ( in ):: A_ 


  Deriv_free_energy = A_*( 2.0*con_*( 1.0 - con_ )**2 &
          -2.0*con_**2*( 1.0 - con_ ) )


end function Deriv_free_energy