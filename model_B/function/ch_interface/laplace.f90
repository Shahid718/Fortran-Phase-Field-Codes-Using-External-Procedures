!-------------------------------------------------------------------
!
!  This is the external subprogram for Laplace evaluation
!
!  The function is pure function
!
!  Modified   :
!		11 August 2023
!
!------------------------------------------------------------------


pure function Laplacian ( Nx, Ny, con_)
  implicit none
  
  integer ( 4 ), intent ( in)  :: Nx, Ny
  real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: con_
  real ( 8 ), dimension ( Nx, Ny )                :: laplacian
  integer ( 4 ) :: i_, j_, ip_, jp_,im_, jm_
  real ( 8) :: dx_, dy_

  dx_ = 1.0
  dy_ = 1.0

  
  do i_ = 1 , Nx
     do j_= 1 , Ny

     jp_ = j_ + 1
     jm_ = j_ - 1

     ip_ = i_ + 1
     im_ = i_ - 1

     if ( im_ == 0 ) im_ = Nx
     if ( ip_ == ( Nx + 1 ) ) ip_ = 1
     if ( jm_ == 0 ) jm_ = Ny
     if ( jp_ == ( Ny + 1 ) ) jp_ = 1


     Laplacian(i_,j_) = ( con_(ip_,j_) + con_(im_,j_) + con_(i_,jm_) + &
          con_(i_,jp_) - 4.0*con_(i_,j_) ) / ( dx_*dy_ )             

    end do
  end do



end function Laplacian
