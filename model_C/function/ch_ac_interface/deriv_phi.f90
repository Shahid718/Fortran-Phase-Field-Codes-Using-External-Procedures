  pure function Deriv_free_energy_wrt_phi ( A, B, D, con, phi ) 
    implicit none

    integer ( 4 ), parameter                        :: Nx = 128
    integer ( 4 ), parameter                        :: Ny = 128
    real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: con, phi
    real ( 8 ), intent ( in )                       :: A, B, D
	real ( 8 ), dimension ( Nx, Ny )                :: deriv_free_energy_wrt_phi


    Deriv_free_energy_wrt_phi = -A*con*con*( 3*phi**2*( 10 - 15*phi + 6*phi**2 ) + phi**3* &
         ( 12*phi - 15 )) + 2*B*(1 - con)*(1 - con)*( 3*phi**2*( 10 - 15*phi + &
         6*phi**2 ) + phi**3*( 12*phi - 15 )) + 2*D*phi*(1 - phi)*(1 - 2*phi )


  end function Deriv_Free_Energy_wrt_phi