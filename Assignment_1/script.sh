# Bash shell script to implement the optimization, parallelisation, and standard library codes.
#
# The script contains a nested loop which is split into two parts - a part to compile and generate executable files with the selected optimizations and parallelization, and, a second part to run the executable
#
#      Loop 1: To select the standard library and/or parallelisation approach .
#       The selected cases for Loop 1 would be (i) Double Loop (ii) Lapack (iii) OpenMP & (iv) OpenMP and BLAS
#
#           Loop 2: To select compiler
#            The cases are (i) GNU gfortran & (ii) Intel ifort
#
#                  Loop 3: To select compiler optimization
#                   The cases are (i) No optimization (-o0) & (ii) Aggressive optimization (-o3)
#
#                       Compile the file based on the standard library and/or parallelisation approach and generate executable file test.x
#
#                       Loop 4: To run test.x with different number of threads
#                        The number of threads are 1, 2 & 4
#                       End Loop 4
#
#                  End Loop 3
#
#           End Loop 2
#
#      End Loop 1

echo "----------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------"
echo "6030G HPC                                                 Assignment 1, 2018"
echo "Parikshit Bajpai                                         Student # 100693928"
echo "----------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------"


echo "Starting Computation..."
# The following nested loop is for compiling and generating executable files for the different test cases
for computation in double lapack omp blas_omp # Loop 1: Select the approach
do
    echo "Computational approach: $computation"
    for compiler in gfortran ifort # Loop 2: Select the compiler
    do
        echo "Compiler: $compiler"
        for optimization in o0 o3 # Loop 3: Select the compiler optimization
	    do
            echo "Compiler Optimization: -$optimization"
            case $computation in
                double)
                    echo "double"
                    echo "commamd: $compiler -$optimization -o test.x matvec.f90"
                    $compiler -$optimization -o test.x matvec.f90
                    ;;
                lapack)
                    echo "lapack"
                    echo "commamd: $compiler -$optimization -o test.x matvec_blas.f90 -L/usr/lib/libblas -lblas"
                    $compiler -$optimization -o test.x matvec_BLAS.f90 -L/usr/lib/libblas -lblas # !!! Make sure BLAS path is correct
                    ;;
                omp)
                    echo "omp"
                    echo "commamd: $compiler -$optimization -fopenmp -o test.x matvec_omp.f900"
                    $compiler -$optimization -fopenmp -o test.x matvec_opm_test.f90
                    ;;
                blas_omp)
                    echo "blas_omp"
                    echo "$compiler -$optimization -fopenmp -o test.x matvec_opm_BLAS.f90 -L/usr/lib/libblas -lblas"
                    $compiler -$optimization -fopenmp -o test.x matvec_opm_BLAS.f90 -L/usr/lib/libblas -lblas # !!! Make sure BLAS path is correct
                    ;;
                *)
                    echo "Error: this option is not available................"
            esac

            for OMP_NUM_THREADS in 1 2 4 # Loop 4: Run executable with 1, 2, or 4 threads
                do
                echo "Number of Threads: $OMP_NUM_THREADS"
                export OMP_NUM_THREADS=$OMP_NUM_THREADS
                ./test.x
            done
	    done
    done
done

echo "Note: The computer was not swapping during computation."



echo "-------------------------------------End-------------------------------------"