!-------------------------------------------------------------------
!
!  This is the external subprogram for output files
!
!
!  Modified :
!             12 September 2023
!
!------------------------------------------------------------------



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


  open ( unit = 1, file = 'parameters.txt', status = 'replace' )


  write ( 1, * ) ""
  write ( 1, * ) '------------------------------------------------------------'
  write ( 1, * ) '   Input Parameters for CahnHilliard-AllenCahn Equation     '
  write ( 1, * ) '------------------------------------------------------------'
  write ( 1, * ) ""
  write ( 1, 100 ) Nx
  write ( 1, 200 ) Ny
  write ( 1, 300 ) no_of_steps
  write ( 1, 400 ) dt
  write ( 1, 500 ) mobility_con
  write ( 1, 600 ) mobility_phi
  write ( 1, 700 ) grad_coef_con
  write ( 1, 800 ) grad_coef_phi
  write ( 1, 900 ) compute_time
  write ( 1, * ) ""
  write ( 1, * ) '------------------------------------------------------------'

  close ( 1 )

100 format ( 6x, 'Nx', 23x, ' = ', i3 )
200 format ( 6x, 'Ny', 23x, ' = ', i3 )
300 format ( 6x, 'number of steps', 10x, ' = ', i5 )
400 format ( 6x, 'time difference', 10x, ' = ', f4.2 )
500 format ( 6x, 'Mobility of con', 10x, ' = ', f3.1 )
600 format ( 6x, 'mobility of phi', 10x, ' = ', f3.1 )
700 format ( 6x, 'gradient coefficient con', 1x, ' = ', f3.1 )
800 format ( 6x, 'gradient coefficient phi', 1x, ' = ', f3.1 )
900 format ( 6x, 'computed time in seconds', 1x, ' = ', f4.2 )


  ! con and phi files


  write ( filename1, '( "con_", i0.3,".dat" )' ) no_of_steps
  write ( filename2, '( "phi_", i0.3,".dat" )' ) no_of_steps

  open ( 2, file = filename1, status = 'replace' )
  open ( 3, file = filename2, status = 'replace' )

  do i = 1, Nx    
     write ( 2, * ) ( con(i,j), j = 1, Ny )
     write ( 3, * ) ( phi(i,j), j = 1, Ny )
  end do

  close ( 2 )
  close ( 3 )



end subroutine output_files
