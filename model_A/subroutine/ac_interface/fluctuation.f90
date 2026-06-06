!------------------------------------------------------------------
!
!  This is the external subprogram for thermal fluctuation
!
!
!  Modified   :
!					 18 April 2023
!
!------------------------------------------------------------------


subroutine Introduce_fluctuation ( phi_, initial_phi_, noise_ )
    implicit none
    
    
    integer ( 4 ), parameter                         :: Nx = 64
    integer ( 4 ), parameter                         :: Ny = 64  
    real ( 8 ), intent ( in )                        :: noise_
    real ( 8 ), intent ( in )                        :: initial_phi_
    real ( 8 ), dimension ( Nx, Ny ), intent ( out ) :: phi_
    real ( 8 ), dimension ( Nx, Ny )                 :: r
    
    
    call random_number ( r )
    
    phi_ = initial_phi_ + noise_*( 0.5 - r )
    

end subroutine Introduce_fluctuation