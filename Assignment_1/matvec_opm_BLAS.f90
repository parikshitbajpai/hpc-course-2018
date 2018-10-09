!------------------------Matrix Vector Multiplication--------------------!
!   This code executes matrix-vector multiplication using OpenMP & BLAS  !

!    Note: The matrix size in this program has been fixed to 8192*8192   !

module globals
  ! Globally used stuff
use omp_lib
implicit none
integer :: n
end module globals

module auxiliary
! Useful stuff
use globals
implicit none
double precision, allocatable, dimension(:,:) :: A
double precision, allocatable, dimension(:) :: v,w
contains
subroutine make_random_matrix

call random_number(A)

end subroutine make_random_matrix

subroutine make_random_vector

call random_number(v)

end subroutine make_random_vector
end module auxiliary

program main
! Naive matrix-vector product computation
use globals
use auxiliary
implicit none
integer :: i,j,p
double precision :: wtime,begin,end

! Set the  matrix size to 2^13 = 8192. To change matrix size edit p
   p=13
   n=2**p

! Allocate and de-allocate inside the loop
   allocate(A(n,n),v(n),w(n))
   
   call make_random_matrix
   call make_random_vector

! GNU Fortran implementation of the CPU clock
	
   !$omp parallel
   begin=omp_get_wtime()
  
      call dgemv("N", n, n, 1.0D0, a, n, v, 1, 0.0D0, w, 1) ! Call to routine DGEMV in BLAS

   end=omp_get_wtime()
   !$omp end parallel
   wtime=end-begin

   print *,n,wtime

   deallocate(A,v,w)

end program main