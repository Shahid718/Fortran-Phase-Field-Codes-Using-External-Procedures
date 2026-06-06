
!   This program uses external subprograms for Cahn-Hilliard Equation.
!   The program shows the use of external statment.
!
!         
!   Author :
!              Shahid Maqbool
! 
!   Modified :
!                19 April 2023, 22 July 2023
!
!   To compile and run :
!                          Check ReadMe
!              
!------------------------------------------------------------------------------

program fd_ch_test
  implicit none



  ! ===========================================================================
  !                           external statements
  ! ===========================================================================



  external Introduce_fluctuation
  external Set_boundary_conditions
  external Compute_derivative_free_energy
  external Evaluate_laplacian
  external Perform_time_integration
  external Output_files



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