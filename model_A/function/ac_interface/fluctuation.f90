!------------------------------------------------------------------
!
!  This is the external subprogram for thermal fluctuation
!
!
!  Modified   :
!		10 August 2023
!
!------------------------------------------------------------------


pure function Introduce_fluctuation ( initial_phi_, noise_,r_ )
  implicit none

  integer ( 4 ), parameter         :: Nx = 64
  integer ( 4 ), parameter         :: Ny = 64
  real ( 8 ), intent ( in )        :: noise_
  real ( 8 ), intent ( in )        :: initial_phi_
  real ( 8 ), dimension ( Nx, Ny ) :: Introduce_fluctuation
  real ( 8 ), dimension ( Nx, Ny ), intent(in) :: r_


  Introduce_fluctuation = initial_phi_ + noise_*( 0.5 - r_ )


end function Introduce_fluctuation