!-------------------------------------------------------------------------
!
!  This is the external subprogram for finite difference implementation
!
!
!  Modified :
!		18 April 2023
!
!--------------------------------------------------------------------------



pure subroutine Perform_time_integration ( con_, dt_, mobility_, &
     & lap_dummy_, i_, j_ )
  implicit none


  integer ( 4 ), parameter                            :: Nx = 64
  integer ( 4 ), parameter                            :: Ny = 64 
  real ( 8 ), intent ( in )                           :: dt_
  real ( 8 ), intent ( in )                           :: mobility_
  real ( 8 ), dimension ( Nx, Ny ), intent ( in )     :: lap_dummy_
  real ( 8 ), dimension ( Nx, Ny ), intent ( in out ) :: con_
  integer ( 4 ), intent ( in )                        :: i_, j_


  con_(i_,j_) = con_(i_,j_) + dt_*mobility_*lap_dummy_(i_,j_)


end subroutine Perform_time_integration
