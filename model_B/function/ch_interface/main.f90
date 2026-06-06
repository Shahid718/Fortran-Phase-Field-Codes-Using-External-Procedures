
!   This program uses external subprograms for Allen-Cahn Equation.
!   This program uses Functions.
!   The program uses Inteface Blocks.
!         
!   Author :
!              Shahid Maqbool
! 
!   Modified :
!                11 August 2023
!
!   To compile and run :
!                          Check ReadMe
!              
!------------------------------------------------------------------------------


program fd_ch_test
  implicit none


  ! ===========================================================================
  !                           Interface Blocks
  ! ===========================================================================


  INTERFACE
     pure function Introduce_fluctuation ( initial_con_, noise_,r_ )
       implicit none

       integer ( 4 ), parameter         :: Nx = 64
       integer ( 4 ), parameter         :: Ny = 64
       real ( 8 ), intent ( in )        :: noise_
       real ( 8 ), intent ( in )        :: initial_con_
       real ( 8 ), dimension ( Nx, Ny ) :: Introduce_fluctuation
       real ( 8 ), dimension ( Nx, Ny ), intent(in) :: r_

     end function Introduce_fluctuation
  END INTERFACE



  INTERFACE
     pure function Deriv_free_energy ( A_, con_)
       implicit none

       integer ( 4 ), parameter :: Nx = 64
       integer ( 4 ), parameter :: Ny = 64
       real ( 8 ), dimension ( Nx, Ny ) :: deriv_free_energy
       real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: con_
       real ( 8 ), intent ( in ):: A_ 

     end function Deriv_free_energy
  END INTERFACE



  INTERFACE
     pure  function Laplacian ( Nx, Ny, con_ )
       implicit none

       integer ( 4 ), intent ( in )                    :: Nx, Ny
       real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: con_
       real ( 8 ), dimension ( Nx, Ny )                :: laplacian
       integer ( 4 ) :: i_, j_, ip_, jp_,im_, jm_
       real ( 8) :: dx_, dy_

     end function Laplacian
  END INTERFACE


  INTERFACE
     subroutine output_files( con,Nx,Ny,no_of_steps,dt,initial_con,mobility,grad_coef,noise,A,compute_time )

       real ( 8 ), dimension ( Nx, Ny ), intent ( in )  :: con
       integer ( 4 ), intent ( in ) :: Nx 
       integer ( 4 ), intent ( in ) :: Ny  
       integer ( 4 ), intent ( in ) :: no_of_steps 
       real ( 8 )   , intent ( in ) :: dt 
       real ( 8 )   , intent ( in ) :: initial_con 
       real ( 8 )   , intent ( in ) :: mobility
       real ( 8 )   , intent ( in ) :: grad_coef
       real ( 8 )   , intent ( in ) :: noise 
       real ( 8 )   , intent ( in ) :: A
       real ( 8 )   , intent ( in ) :: compute_time

     end subroutine output_files
  END INTERFACE



  ! ===========================================================================
  !                                parameters
  ! ===========================================================================


  ! simulation cell 

  integer ( 4 ), parameter :: Nx = 64
  integer ( 4 ), parameter :: Ny = 64

  ! time integration

  integer ( 4 ), parameter :: no_of_steps = 10000
  integer ( 4)             :: frequency = 1000
  integer (4 )             :: step 
  real ( 8 )   , parameter :: dt = 0.01
  real ( 8 )               :: start, finish, compute_time

  ! material specific 

  real ( 8 ) :: initial_con = 0.4
  real ( 8 ) :: mobility = 1.0
  real ( 8 ) :: grad_coef = 0.5

  ! microstructure

  real ( 8 ) :: noise = 0.02
  real ( 8 ) :: A = 1.0
  real ( 8 ) , dimension ( Nx, Ny ) :: r, con, dfdcon, dummy_con


  call cpu_time ( start )



  ! ===========================================================================
  !                           initial microstructure
  ! ===========================================================================



  call random_number ( r )
  con =  Introduce_fluctuation( initial_con, noise, r )



  ! ===========================================================================
  !                         evolution of microstructure 
  ! ===========================================================================



  time_loop: do step = 1, no_of_steps


     dfdcon = Deriv_free_energy ( A, con )

     dummy_con = dfdcon - grad_coef*Laplacian ( Nx, Ny, con )

     con = con + dt*mobility*Laplacian( Nx, Ny, dummy_con ) 



     ! adjust order parameter in range

     where ( con >= 0.99999 )  con = 0.99999
     where ( con < 0.00001  )  con = 0.00001


     ! print steps

     if ( mod ( step, frequency ) .eq. 0 )  print *, 'Done steps  = ', step


  end do time_loop


  call cpu_time ( finish )

  compute_time = finish - start

  

  ! ===========================================================================
  !                                  Output 
  ! ===========================================================================



  call output_files( con,Nx,Ny,no_of_steps,dt,initial_con,mobility,grad_coef,noise,A,compute_time )


end program fd_ch_test