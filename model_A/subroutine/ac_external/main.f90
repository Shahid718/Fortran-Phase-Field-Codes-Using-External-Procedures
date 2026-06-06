
!   This program uses external subprograms for Allen-Cahn Equation.
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


program fd_ac_test
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
  integer ( 4 ), parameter :: dx = 2
  integer ( 4 ), parameter :: dy = 2

  ! time integration

  integer ( 4 ), parameter :: no_of_steps = 1500
  integer ( 4)             :: frequency = 100
  integer (4 )             :: step 
  real ( 8 )   , parameter :: dt = 0.01
  real ( 8 )               :: start, finish, compute_time

  ! material specific 

  real ( 8 )   , parameter :: initial_phi = 0.5
  real ( 8 )   , parameter :: mobility = 1.0
  real ( 8 )   , parameter :: grad_coef = 1.0

  ! microstructure

  real ( 8 )   , parameter :: noise = 0.02
  real ( 8 )   , parameter :: A  = 1.0
  real ( 8 )   , dimension ( Nx, Ny ) :: phi, dfdphi
  real ( 8 )   , dimension ( Nx, Ny ) :: lap_phi, r
  integer ( 4 )            :: i, j, jp, jm, ip, im


  call cpu_time ( start )


  
  ! ===========================================================================
  !                           initial microstucture
  ! ===========================================================================


  call random_number ( r )
  call Introduce_fluctuation ( phi, initial_phi, noise, r )



  ! ===========================================================================
  !                         evolution of microstructure 
  ! ===========================================================================



  time_loop: do step = 1, no_of_steps


     do i = 1, Nx
        do j = 1, Ny


           call Set_boundary_conditions ( i, j, jp, jm, ip, im )

           call Compute_derivative_free_energy ( A, phi, dfdphi, i, j )

           call Evaluate_laplacian ( lap_phi, phi, dx, dy, &
                & i , j, ip, jp, im, jm )

           call Perform_time_integration ( phi, dt, mobility, &
                & grad_coef, lap_phi, dfdphi, i, j )


        end do
     end do


     ! adjust order parameter in range

     if ( phi(i,j) >= 0.99999 ) phi(i,j) = 0.99999
     if ( phi(i,j) < 0.00001 )  phi(i,j) = 0.00001


     ! print steps

     if ( mod ( step, frequency ) .eq. 0 )  print *, 'Done steps  = ', step


  end do time_loop


  call cpu_time ( finish )


  compute_time = finish - start



  ! ===========================================================================
  !                                  Output 
  ! ===========================================================================



  call output_files( phi,Nx,Ny,no_of_steps,dt,initial_phi,mobility,grad_coef,noise,A,compute_time )


end program fd_ac_test