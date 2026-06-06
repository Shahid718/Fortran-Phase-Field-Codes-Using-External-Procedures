!------------------------------------------------------------------
!
!  This is the external subprogram for thermal fluctuation
!
!
!  Modified :
!		18 April 2023
!
!------------------------------------------------------------------


subroutine Introduce_fluctuation ( con_, initial_con_, noise_ )
  implicit none

  integer ( 4 ), parameter                         :: Nx = 64
  integer ( 4 ), parameter                         :: Ny = 64  
  real ( 8 ), intent ( in )                        :: noise_
  real ( 8 ), intent ( in )                        :: initial_con_
  real ( 8 ), dimension ( Nx, Ny ), intent ( out ) :: con_
  real ( 8 ), dimension ( Nx, Ny )                 :: r_

  call random_number ( r_ )

  con_ = initial_con_ + noise_*( 0.5 - r_ )


end subroutine Introduce_fluctuation
