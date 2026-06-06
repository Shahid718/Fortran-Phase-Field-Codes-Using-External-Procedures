pure function Deriv_free_energy_wrt_con ( A, B, con, phi ) 
    implicit none

    integer ( 4 ), parameter                        :: Nx = 128
    integer ( 4 ), parameter                        :: Ny = 128
    real ( 8 ), dimension ( Nx, Ny )                :: deriv_free_energy_wrt_con
    real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: con, phi
    real ( 8 ), intent ( in )                       :: A, B


    Deriv_free_energy_wrt_con = 2*A*con*(1 - ( phi**3*( 10 - 15*phi + 6*phi**2 ) ) ) & 
         - 2*B*(1 - con)*( phi**3*( 10 - 15*phi + 6*phi**2 ) )


end function Deriv_Free_Energy_wrt_con