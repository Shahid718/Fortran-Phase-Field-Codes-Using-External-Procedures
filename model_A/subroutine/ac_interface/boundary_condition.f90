!-------------------------------------------------------------------
!
!  This is the external subprogram for boundary conditions
!
!
!  Modified   :
!					 18 April 2023
!
!-------------------------------------------------------------------



pure subroutine Set_boundary_conditions ( i_, j_, jp_, jm_, ip_, im_ )
    implicit none
    
    
    integer ( 4 ), parameter      :: Nx_ = 64
    integer ( 4 ), parameter      :: Ny_ = 64  
    integer ( 4 ), intent ( in )  :: i_, j_
    integer ( 4 ), intent ( out ) :: jp_, jm_, ip_, im_
    
    
    jp_ = j_ + 1
    jm_ = j_ - 1
    
    ip_ = i_ + 1
    im_ = i_ - 1
    
    if ( im_ == 0 ) im_ = Nx_
    if ( ip_ == ( Nx_ + 1 ) ) ip_ = 1
    if ( jm_ == 0 ) jm_ = Ny_
    if ( jp_ == ( Ny_ + 1 ) ) jp_ = 1
    

end subroutine Set_boundary_conditions