!                                                                             
!   The program uses external subprogram for solving model C.
!   This program uses Functions.
!	This program uses INTERFACE BLOCKS.
!                                                                             
!
!   Author  :
!               Shahid Maqbool
!
!   Modified   :
!                    12 September 2023
!
!   To compile and run :
!                            check ReadMe file
!
!------------------------------------------------------------------------------


program fd_ch_ac_test
  implicit none



  ! ============================================================================
  !                           INTERFACE BLOCKS
  ! ============================================================================



  INTERFACE
     pure function Initial_microstructure (  radius_ )
       implicit none

       integer ( 4 ), parameter         :: Nx = 128
       integer ( 4 ), parameter         :: Ny = 128
       real ( 8 ), intent ( in )        :: radius_
       real ( 8 ), dimension ( Nx, Ny ) :: Initial_microstructure 
       integer ( 4 )                    :: i, j

     end function Initial_microstructure
  END INTERFACE


  INTERFACE
     pure function Deriv_free_energy_wrt_con ( A, B, con, phi ) 
       implicit none

       integer ( 4 ), parameter                        :: Nx = 128
       integer ( 4 ), parameter                        :: Ny = 128
       real ( 8 ), dimension ( Nx, Ny )                :: deriv_free_energy_wrt_con
       real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: con, phi
       real ( 8 ), intent ( in )                       :: A, B

     end function Deriv_Free_Energy_wrt_con
  END INTERFACE



  INTERFACE
     pure function Deriv_free_energy_wrt_phi ( A, B, D, con, phi ) 
       implicit none

       integer ( 4 ), parameter                        :: Nx = 128
       integer ( 4 ), parameter                        :: Ny = 128
       real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: con, phi
       real ( 8 ), intent ( in )                       :: A, B, D
       real ( 8 ), dimension ( Nx, Ny )                :: deriv_free_energy_wrt_phi

     end function Deriv_Free_Energy_wrt_phi
  END INTERFACE



  INTERFACE
     pure function Laplacian ( order_parameter) 
       implicit none

       integer ( 4 ), parameter                        :: Nx = 128
       integer ( 4 ), parameter                        :: Ny = 128
       real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: order_parameter 
       real ( 8 ), dimension ( Nx, Ny )                :: Laplacian 
       integer ( 4 ) :: i , j, jp, jm, ip, im , dx, dy

     end function Laplacian
  END INTERFACE


  
  INTERFACE
     subroutine output_files( con,phi,Nx,Ny,no_of_steps,dt, mobility_con, &
          & mobility_phi,grad_coef_con,grad_coef_phi,compute_time )

       real ( 8 ), dimension ( Nx, Ny ), intent ( in )  :: con
       real ( 8 ), dimension ( Nx, Ny ), intent ( in )  :: phi
       integer ( 4 ), intent ( in ) :: Nx 
       integer ( 4 ), intent ( in ) :: Ny  
       integer ( 4 ), intent ( in ) :: no_of_steps 
       real ( 8 )   , intent ( in ) :: dt 
       real ( 8 )   , intent ( in ) :: mobility_con
       real ( 8 )   , intent ( in ) :: mobility_phi
       real ( 8 )   , intent ( in ) :: grad_coef_con
       real ( 8 )   , intent ( in ) :: grad_coef_phi
       real ( 8 )   , intent ( in ) :: compute_time
       character ( len = 80 )       :: filename1, filename2

     end subroutine output_files
  END INTERFACE



  ! ============================================================================
  !                                parameters
  ! ============================================================================



  ! simulation cell

  integer ( 4 ), parameter :: Nx = 128
  integer ( 4 ), parameter :: Ny = 128
  integer ( 4 ), parameter :: dx = 1
  integer ( 4 ), parameter :: dy = 1


  ! time integration

  integer ( 4 ), parameter :: no_of_steps = 10000
  integer ( 4)             :: nprint = 1000
  integer (4 )             :: istep 
  real ( 8 )   , parameter :: dt = 0.03
  real ( 8 )               :: start, finish, compute_time


  ! material specific

  real ( 8 )   , parameter :: A = 1.0
  real ( 8 )   , parameter :: B = 1.0
  real ( 8 )   , parameter :: D = 1.0
  real ( 8 )   , parameter :: mobility_con = 0.5
  real ( 8 )   , parameter :: mobility_phi = 0.5
  real ( 8 )   , parameter :: grad_coef_con = 1.5
  real ( 8 )   , parameter :: grad_coef_phi = 1.5
  real ( 8 )   , parameter :: radius = 10.0


  ! microstructure 

  real ( 8 )   , dimension ( Nx, Ny ) :: con, phi, dfdcon, dfdphi, dummy_con


  call cpu_time (start)



  ! ===========================================================================
  !                            initial microstucture
  ! ===========================================================================



  con = 0.02
  phi = 0.0

  con =  Initial_microstructure( radius )
  phi =  Initial_microstructure( radius )



  ! ===========================================================================
  !                         evolution of microstructure 
  ! ===========================================================================



  time_loop: do istep = 1, no_of_steps


     dfdcon = Deriv_free_energy_wrt_con ( A, B, con, phi )
     dfdphi = Deriv_free_energy_wrt_phi ( A, B, D, con, phi ) 


     ! dummy array for concentration

     dummy_con = dfdcon - grad_coef_con*Laplacian( con )


     ! time integration

     con = con + dt*mobility_con*Laplacian( dummy_con )
     phi = phi - dt*mobility_phi*( dfdphi - grad_coef_phi*Laplacian( phi ) )



     ! adjust order parameter in range

     where ( phi >= 0.99999 )  phi = 0.99999
     where ( phi < 0.00001 )   phi = 0.00001


     ! print steps on the console

     if ( mod( istep, nprint ) .eq. 0 )  print *, 'Done steps  =  ', istep



  end do time_loop

  call cpu_time (finish)

  compute_time = finish - start



  ! =========================================================================
  !                                  Output 
  ! =========================================================================



  call output_files( con,phi,Nx,Ny,no_of_steps,dt, mobility_con, &
          & mobility_phi,grad_coef_con,grad_coef_phi,compute_time )



end program fd_ch_ac_test