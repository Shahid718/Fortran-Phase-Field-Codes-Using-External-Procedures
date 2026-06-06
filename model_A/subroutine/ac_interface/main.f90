
!   This program uses external subprograms for Allen-Cahn Equation.
!   This program uses INTERFACE BLOCK
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


program fd_ac_test
  implicit none


  ! ===========================================================================
  !                           Interface Blocks
  ! ===========================================================================


  INTERFACE
     SUBROUTINE Introduce_fluctuation ( phi_, initial_phi_, noise_ )
       integer ( 4 ), parameter                         :: Nx = 64
       integer ( 4 ), parameter                         :: Ny = 64
       real ( 8 ), intent ( in )                        :: noise_
       real ( 8 ), intent ( in )                        :: initial_phi_
       real ( 8 ), dimension ( Nx, Ny ), intent ( out ) :: phi_
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
     pure subroutine Compute_derivative_free_energy ( A_, phi_, dfdphi_, i_, j_ )
       implicit none

       integer ( 4 ), parameter                         :: Nx = 64
       integer ( 4 ), parameter                         :: Ny = 64 
       real ( 8 ), intent ( in )                        :: A_
       real ( 8 ), dimension ( Nx, Ny ), intent ( in )  :: phi_
       real ( 8 ), dimension ( Nx, Ny ), intent ( out ) :: dfdphi_
       integer ( 4 ), intent ( in )                     :: i_, j_

     END SUBROUTINE Compute_derivative_free_energy
  END INTERFACE



  INTERFACE
     pure subroutine Evaluate_laplacian ( lap_phi_, phi_, dx_, dy_, &
          & i_ , j_, ip_, jp_, im_, jm_ )
       implicit none

       integer ( 4 ), parameter                        :: Nx = 64
       integer ( 4 ), parameter                        :: Ny = 64 
       real ( 8 ), dimension ( Nx, Ny ), intent ( out ):: lap_phi_
       real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: phi_ 
       integer ( 4 ), intent ( in )                    :: dx_, dy_, i_, j_
       integer ( 4 ), intent ( in )                    :: ip_, jp_
       integer ( 4 ), intent ( in )                    :: im_, jm_

     END SUBROUTINE Evaluate_laplacian
  END INTERFACE



  INTERFACE
     pure subroutine Perform_time_integration ( phi_, dt_, mobility_, &
          & grad_coef_, lap_phi_, dfdphi_, i_, j_ )
       implicit none

       integer ( 4 ), parameter                            :: Nx = 64
       integer ( 4 ), parameter                            :: Ny = 64 
       real ( 8 ), intent ( in )                           :: dt_
       real ( 8 ), intent ( in )                           :: grad_coef_
       real ( 8 ), intent ( in )                           :: mobility_
       real ( 8 ), dimension ( Nx, Ny ), intent ( in )     :: lap_phi_
       real ( 8 ), dimension ( Nx, Ny ), intent ( in )     :: dfdphi_
       real ( 8 ), dimension ( Nx, Ny ), intent ( in out ) :: phi_
       integer ( 4 ), intent ( in )                        :: i_, j_

     END SUBROUTINE Perform_time_integration
  END INTERFACE


  INTERFACE
     subroutine output_files( phi,Nx,Ny,no_of_steps,dt,initial_phi,mobility,grad_coef,noise,A,compute_time )

       real ( 8 ), dimension ( Nx, Ny ), intent ( in )  :: phi
       integer ( 4 ), intent ( in ) :: Nx 
       integer ( 4 ), intent ( in ) :: Ny  
       integer ( 4 ), intent ( in ) :: no_of_steps 
       real ( 8 )   , intent ( in ) :: dt 
       real ( 8 )   , intent ( in ) :: initial_phi 
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
  integer ( 4 ), parameter :: dx = 2
  integer ( 4 ), parameter :: dy = 2

  ! time integration

  integer ( 4 ), parameter :: no_of_steps = 1500
  integer ( 4)             :: frequency = 100
  integer (4 )             :: step 
  real ( 8 )   , parameter :: dt = 0.01
  real ( 8 )               :: start, finish, compute_time

  ! material specific 

  real ( 8 )   :: initial_phi = 0.5
  real ( 8 )   :: mobility = 1.0
  real ( 8 )   :: grad_coef = 1.0

  ! microstructure

  real ( 8 )   :: noise = 0.02
  real ( 8 )   :: A  = 1.0
  real ( 8 )   , dimension ( Nx, Ny ) :: phi, dfdphi
  real ( 8 )   , dimension ( Nx, Ny ) :: lap_phi
  integer ( 4 )            :: i, j, jp, jm, ip, im


  call cpu_time ( start )



  ! ===========================================================================
  !                           initial microstucture
  ! ===========================================================================



  call Introduce_fluctuation ( phi, initial_phi, noise )



  ! ===========================================================================
  !                         evolution of microstructure 
  ! ===========================================================================



  time_loop: do step = 1, no_of_steps


     do i = 1, Nx
		do j= 1, Ny


        call Set_boundary_conditions ( i, j, jp, jm, ip, im )

        call Compute_derivative_free_energy ( A, phi, dfdphi, i, j )

        call Evaluate_laplacian ( lap_phi, phi, dx, dy, &
             & i , j, ip, jp, im, jm )

        call Perform_time_integration ( phi, dt, mobility, &
             & grad_coef, lap_phi, dfdphi, i, j )


        ! adjust order parameter in range

        if ( phi(i,j) >= 0.99999 ) phi(i,j) = 0.99999
        if ( phi(i,j) < 0.00001 )  phi(i,j) = 0.00001


		end do 
	 end do


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