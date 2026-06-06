
!   This program uses external subprograms for Cahn-Hilliard Equation.
!   The program shows the use of INTERFACE BLOCKS.
!         
!   Author :
!              Shahid Maqbool
! 
!   Modified :
!                19 April 2023
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
     subroutine Introduce_fluctuation ( con_, initial_con_, noise_ )
       implicit none

       integer ( 4 ), parameter                         :: Nx = 64
       integer ( 4 ), parameter                         :: Ny = 64  
       real ( 8 ), intent ( in )                        :: noise_
       real ( 8 ), intent ( in )                        :: initial_con_
       real ( 8 ), dimension ( Nx, Ny ), intent ( out ) :: con_
       real ( 8 ), dimension ( Nx, Ny )                 :: r_

     END SUBROUTINE Introduce_fluctuation
  END INTERFACE


  INTERFACE
     pure subroutine Set_boundary_conditions ( i_, j_, jp_, jm_, ip_, im_ )
       implicit none

       integer ( 4 ), parameter      :: Nx_ = 64
       integer ( 4 ), parameter      :: Ny_ = 64  
       integer ( 4 ), intent ( in )  :: i_, j_
       integer ( 4 ), intent ( out ) :: jp_, jm_, ip_, im_

     END SUBROUTINE Set_boundary_conditions
  END INTERFACE


  INTERFACE
     pure subroutine Compute_derivative_free_energy ( A_, con_, dfdcon_, i_, j_ )
       implicit none


       integer ( 4 ), parameter                         :: Nx = 64
       integer ( 4 ), parameter                         :: Ny = 64 
       real ( 8 ), intent ( in )                        :: A_
       real ( 8 ), dimension ( Nx, Ny ), intent ( in )  :: con_
       real ( 8 ), dimension ( Nx, Ny ), intent ( out ) :: dfdcon_
       integer ( 4 ), intent ( in )                     :: i_, j_

     END SUBROUTINE Compute_derivative_free_energy
  END INTERFACE


  INTERFACE
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

     END SUBROUTINE Evaluate_laplacian
  END INTERFACE


  INTERFACE
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
     end subroutine Perform_time_integration
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

     END SUBROUTINE output_files
  END INTERFACE



  ! ===========================================================================
  !                                parameters
  ! ===========================================================================


  ! simulation cell 

  integer ( 4 ), parameter :: Nx = 64
  integer ( 4 ), parameter :: Ny = 64
  integer ( 4 ), parameter :: dx = 1
  integer ( 4 ), parameter :: dy = 1

  ! time integration

  integer ( 4 ), parameter :: no_of_steps = 10000
  integer ( 4)             :: frequency = 1000
  integer (4 )             :: step 
  real ( 8 )   , parameter :: dt = 0.01
  real ( 8 )               :: start, finish, compute_time

  ! material specific 

  real ( 8 )   , parameter :: initial_con = 0.4
  real ( 8 )   , parameter :: mobility = 1.0
  real ( 8 )   , parameter :: grad_coef = 0.5

  ! microstructure

  real ( 8 )   , parameter :: noise = 0.02
  real ( 8 )   , parameter :: A  = 1.0
  integer ( 4 )            :: i, j, jp, jm, ip, im
  real ( 8 )   , dimension ( Nx, Ny ) :: con, lap_con, dfdcon
  real ( 8 )   , dimension ( Nx, Ny ) :: dummy_con, lap_dummy


  call cpu_time ( start )



  ! ===========================================================================
  !                           initial microstucture
  ! ===========================================================================



  call Introduce_fluctuation ( con, initial_con, noise )



  ! ===========================================================================
  !                         evolution of microstructure 
  ! ===========================================================================



  time_loop: do step = 1, no_of_steps


     do i = 1, Nx
        do j = 1, Ny


        call Set_boundary_conditions (i, j, jp, jm, ip, im )

        call Compute_derivative_free_energy ( A, con, dfdcon, i, j )

        call Evaluate_laplacian ( lap_con, con, dx, dy, dummy_con, &
             & dfdcon, grad_coef, lap_dummy, i, j, ip, jp, im, jm )

        call Perform_time_integration ( con, dt, mobility, lap_dummy, i, j )


        end do
     end do


     ! adjust concentration in range

     where ( con >= 0.99999 )  con = 0.99999
     where ( con <  0.00001 )  con = 0.00001


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