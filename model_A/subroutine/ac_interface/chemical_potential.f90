!-------------------------------------------------------------------
!
!  This is the external subprogram for derivative of free energy
!
!
!  Modified   :
!					 18 April 2023
!
!------------------------------------------------------------------


pure subroutine Compute_derivative_free_energy ( A_, phi_, dfdphi_, i_, j_ )
    implicit none
    
    integer ( 4 ), parameter                         :: Nx = 64
    integer ( 4 ), parameter                         :: Ny = 64 
    real ( 8 ), intent ( in )                        :: A_
    real ( 8 ), dimension ( Nx, Ny ), intent ( in )  :: phi_
    real ( 8 ), dimension ( Nx, Ny ), intent ( out ) :: dfdphi_
    integer ( 4 ), intent ( in )                     :: i_, j_
    
    
    dfdphi_(i_,j_) = A_*( 2.0*phi_(i_,j_)*( 1.0 - phi_(i_,j_) )**2 &
    *( 1.0 - 2*phi_(i_,j_) ) )
    

end subroutine Compute_derivative_free_energy