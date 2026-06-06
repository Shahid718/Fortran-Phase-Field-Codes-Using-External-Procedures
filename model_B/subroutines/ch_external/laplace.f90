!------------------------------------------------------------------
!
!  This is the external subprogram for Laplace evaluation
!
!
!  Modified   :
!		18 April 2023
!
!------------------------------------------------------------------



pure subroutine Evaluate_laplacian ( lap_con_, con_, dx_, dy_, dummy_con_, &
     & dfdcon_, grad_coef_, lap_dummy_, i_ , j_, ip_, jp_, im_, jm_ )
  implicit none

  integer ( 4 ), parameter                        :: Nx = 64
  integer ( 4 ), parameter                        :: Ny = 64 
  real ( 8 ), intent ( in )                       :: grad_coef_
  real ( 8 ), dimension ( Nx, Ny ), intent ( out ):: lap_con_
  real ( 8 ), dimension ( Nx, Ny ), intent ( out ):: dummy_con_
  real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: con_, dfdcon_
  real ( 8 ), dimension ( Nx, Ny ), intent ( out ):: lap_dummy_
  integer ( 4 ), intent ( in )                    :: dx_, dy_, i_, j_
  integer ( 4 ), intent ( in )                    :: ip_, jp_
  integer ( 4 ), intent ( in )                    :: im_, jm_


  lap_con_(i_,j_) = ( con_(ip_,j_) + con_(im_,j_) + con_(i_,jm_) + con_(i_,jp_) &
       & - 4.0*con_(i_,j_) ) / ( dx_*dy_ )

  dummy_con_(i_,j_) = dfdcon_(i_,j_) - grad_coef_*lap_con_(i_,j_)

  lap_dummy_(i_,j_) = ( dummy_con_(ip_,j_) + dummy_con_(im_,j_) & 
       & + dummy_con_(i_,jm_) + dummy_con_(i_,jp_) &
       & - 4.0*dummy_con_(i_,j_) ) / ( dx_*dy_ )



end subroutine Evaluate_laplacian
