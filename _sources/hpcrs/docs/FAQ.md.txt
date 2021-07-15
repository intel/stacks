# HPCRS Frequently Asked Questions (FAQ)

1. My workload is getting killed with signal 9 and/or signal 7 errors, what’s causing this?
   * The default shared memory provided to Docker* containers is 64MB. This is
     not enough for many applications. Increase the shared memory to 4GB by
     adding the `--shm-size=4G` option to your `docker run` command. 

     See the [Docker run documentation about runtime constraints on
     resources](https://docs.docker.com/engine/reference/run/#runtime-constraints-on-resources)
     for more information.

1. Where are the components located in the Docker* image?
   * Intel software components are installed into the `/opt/intel` directory and
     are sourced using `/etc/profile.d`. For more information, refer to the
     documentation for each component:
      * Intel® MPI: https://software.intel.com/content/www/us/en/develop/documentation/mpi-developer-guide-linux/top/introduction/introducing-intel-mpi-library.html 
      * Intel® MKL: https://software.intel.com/content/www/us/en/develop/documentation/mkl-linux-developer-guide/top.html 
      * Intel® Parallel Studio: https://software.intel.com/content/www/us/en/develop/documentation/get-started-with-parallel-studio-xe/top.html
      * Intel® C++ https://software.intel.com/content/www/us/en/develop/documentation/cpp-compiler-developer-guide-and-reference/top.html
      * Intel® Fortran https://software.intel.com/content/www/us/en/develop/documentation/fortran-compiler-developer-guide-and-reference/top.html

1. I am getting a licensing error similar to the one below when running `icc` or
   `ifort` . What is wrong?

    * Intel® C++ and Intel® Fortran requires a valid license file to use. Place
      your license file under `/opt/intel/licenses/`. See the
      [README](../README.md) for more information.
   
    ```bash 
    Error: A license for Comp-CL could not be obtained.  (-1,359,2).

    Is your license file in the right location and readable?
    The location of your license file should be specified via
    the $INTEL_LICENSE_FILE environment variable.

    License file(s) used were (in this order):
    **  1.  /opt/intel/compilers_and_libraries_2020.1.217/linux/licenses
    **  2.  /opt/intel/licenses/*.lic
    **  3.  //intel/licenses
    **  4.  /opt/intel/compilers_and_libraries_2020.1.217/linux/bin/intel64/../../Licenses
    **  5.  /Licenses
    **  6.  /intel/licenses
    **  7.  /Users/Shared/Library/Application Support/Intel/Licenses
    **  8.  /opt/intel/compilers_and_libraries_2020.1.217/linux/bin/intel64/*.lic

    Please refer http://software.intel.com/sites/support/ for more information..

    icc: error #10052: could not checkout FLEXlm license
    ```


*\*Other names and brands may be claimed as the property of others*