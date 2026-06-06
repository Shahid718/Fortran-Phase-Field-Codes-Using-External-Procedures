!-------------------------------------------------------------------
!
!  This is the external subprogram for output files
!
!
!  Modified :
!		        22 July 2023
!
!------------------------------------------------------------------


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
  character ( len = 80 )       :: filename 


  open ( unit = 1, file = 'parameters.txt', status = 'replace' )


  write ( 1, * ) ""
  write ( 1, * ) '------------------------------------------------'
  write ( 1, * ) '   Input Parameters for Cahn-Hilliard Equation  '
  write ( 1, * ) '------------------------------------------------'
  write ( 1, * ) ""
  write ( 1, 100 ) Nx
  write ( 1, 200 ) Ny
  write ( 1, 300 ) no_of_steps
  write ( 1, 400 ) dt
  write ( 1, 500 ) initial_con
  write ( 1, 600 ) mobility
  write ( 1, 700 ) grad_coef
  write ( 1, 800 ) noise
  write ( 1, 900 ) A
  write ( 1, 1000 ) compute_time
  write ( 1, * ) ""
  write ( 1, * ) '------------------------------------------------'

  close ( 1 )

100 format ( 6x, 'Nx', 23x, ' = ', i2 )
200 format ( 6x, 'Ny', 23x, ' = ', i2 )
300 format ( 6x, 'number of steps', 10x, ' = ', i5 )
400 format ( 6x, 'time difference', 10x, ' = ',f4.2 )
500 format ( 6x, 'initial con', 14x, ' = ', f3.1 )
600 format ( 6x, 'mobility', 17x, ' = ', f3.1 )
700 format ( 6x, 'gradient coefficient', 5x, ' = ', f3.1 )
800 format ( 6x, 'noise', 20x,' = ', f4.2 )
900 format ( 6x, 'barrier height', 11x,' = ', f3.1 )
1000 format ( 6x, 'computed time in seconds', 1x,' = ', f4.2 )


  ! phi file


  write ( filename, '( "con_", i0.3,".dat" )' ) no_of_steps
  open ( 2, file = filename, status = 'replace' )

  do i = 1, Nx    
     write ( 2, * ) ( con(i,j), j = 1, Ny )
  end do

  close ( 2 )



end subroutine output_files