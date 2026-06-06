!-------------------------------------------------------------------------
!
!  This is the external subprogram for finite difference implementation
!
!
!  Modified :
!		18 April 2023
!
!--------------------------------------------------------------------------



pure subroutine Perform_time_integration ( phi_, dt_, mobility_, &
     & grad_coef_, lap_phi_, dfdphi_, i_, j_ )
  implicit none


  integer ( 4 ), parameter                            :: Nx = 64
  integer ( 4 ), parameter                            :: Ny = 64 
  real ( 8 ), intent ( in )                           :: dt_
  real ( 8 ), intent ( in )                           :: grad_coef_
  real ( 8 ), intent ( in )                           :: mobility_
  real ( 8 ), dimension ( Nx, Ny ), intent ( in )     :: lap_phi_
  real ( 8 ), dimension ( Nx, Ny ), intent ( in )     :: dfdphi_
  real ( 8 ), dimension ( Nx, Ny ), intent ( in out ) :: phi_
  integer ( 4 ), intent ( in )                        :: i_, j_


  phi_(i_,j_) = phi_(i_,j_) - dt_*mobility_*( dfdphi_(i_,j_) - &
       & grad_coef_*lap_phi_(i_,j_) ) 



end subroutine Perform_time_integration
