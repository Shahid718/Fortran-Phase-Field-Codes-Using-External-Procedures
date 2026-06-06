pure function Laplacian ( order_parameter) 
    implicit none

    integer ( 4 ), parameter                        :: Nx = 128
    integer ( 4 ), parameter                        :: Ny = 128
    real ( 8 ), dimension ( Nx, Ny ), intent ( in ) :: order_parameter 
    real ( 8 ), dimension ( Nx, Ny )                :: Laplacian 
    integer ( 4 ) :: i , j, jp, jm, ip, im , dx, dy

	dx = 1
	dy = 1


    do i = 1 , Nx
	   do j= 1 , Ny

       jp = j + 1
       jm = j - 1

       ip = i + 1
       im = i - 1

       if ( im == 0 ) im = Nx
       if ( ip == ( Nx + 1 ) ) ip = 1
       if ( jm == 0 ) jm = Ny
       if ( jp == ( Ny + 1 ) ) jp = 1

       Laplacian(i,j) = ( order_parameter(ip,j) + order_parameter(im,j) + & 
            order_parameter(i,jm) + order_parameter(i,jp) - &
            4.0*order_parameter(i,j))  / ( dx*dy )              

       end do
    end do

  end function Laplacian
