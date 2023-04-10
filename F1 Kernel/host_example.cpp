// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
Vendor: Xilinx
Associated Filename: main.c
#Purpose: This example shows a basic vector add +1 (constant) by manipulating
#         memory inplace.
*******************************************************************************/
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS

#include <fcntl.h>
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#ifdef _WINDOWS
#include <io.h>
#else
#include <unistd.h>
#include <sys/time.h>
#endif
#include <assert.h>
// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
Vendor: Xilinx
Associated Filename: main.c
#Purpose: This example shows a basic vector add +1 (constant) by manipulating
#         memory inplace.
*******************************************************************************/
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS

#include <fcntl.h>
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#ifdef _WINDOWS
#include <io.h>
#else
#include <unistd.h>
#include <sys/time.h>
#endif
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <CL/opencl.h>
#include <CL/cl_ext.h>
#include "xclhal2.h"

////////////////////////////////////////////////////////////////////////////////

#define NUM_WORKGROUPS (1)
#define WORKGROUP_SIZE (256)
#define MAX_LENGTH (4096 << 4) // 4096 points; 16 cl_uints per coordinate
#define RCV_LENGTH (256 << 4)  // 256 points; 16 cl_uints per coordinate
#define MEM_ALIGNMENT 4096
#if defined(VITIS_PLATFORM) && !defined(TARGET_DEVICE)
#define STR_VALUE(arg)      #arg
#define GET_STRING(name) STR_VALUE(name)
#define TARGET_DEVICE GET_STRING(VITIS_PLATFORM)
#endif

////////////////////////////////////////////////////////////////////////////////

cl_uint load_file_to_memory(const char *filename, char **result)
{
    cl_uint size = 0;
    FILE *f = fopen(filename, "rb");
    if (f == NULL) {
        *result = NULL;
        return -1; // -1 means file opening fail
    }
    fseek(f, 0, SEEK_END);
    size = ftell(f);
    fseek(f, 0, SEEK_SET);
    *result = (char *)malloc(size+1);
    if (size != fread(*result, sizeof(char), size, f)) {
        free(*result);
        return -2; // -2 means file reading fail
    }
    fclose(f);
    (*result)[size] = 0;
    return size;
}

int main(int argc, char** argv)
{

    cl_int err;          // error code returned from api calls
    cl_uint check_status = 0;
    // int cl_uints_per_word = 64 / sizeof(cl_uint);
    const cl_uint number_of_words_sent = MAX_LENGTH; 
    const cl_uint number_of_words_rcv = RCV_LENGTH;


    cl_platform_id platform_id;         // platform id
    cl_device_id device_id;             // compute device id
    cl_context context;                 // compute context
    cl_command_queue commands;          // compute command queue
    cl_program program;                 // compute programs
    cl_kernel kernel;                   // compute kernel

    cl_uint* h_data;                                // host memory for input vector
    char cl_platform_vendor[1001];
    char target_device_name[1001] = TARGET_DEVICE;

    cl_uint* h_x_n_input = (cl_uint*)aligned_alloc(MEM_ALIGNMENT,(MAX_LENGTH) * sizeof(cl_uint*)); // host memory for input vector
    cl_mem d_x_n;                         // device memory used for a vector

    cl_uint* h_G_x_input = (cl_uint*)aligned_alloc(MEM_ALIGNMENT,MAX_LENGTH * sizeof(cl_uint*)); // host memory for input vector
    cl_mem d_G_x;                         // device memory used for a vector

    cl_uint* h_G_y_input = (cl_uint*)aligned_alloc(MEM_ALIGNMENT,MAX_LENGTH * sizeof(cl_uint*)); // host memory for input vector
    cl_mem d_G_y;                         // device memory used for a vector

    cl_uint* h_R_x_output = (cl_uint*)aligned_alloc(MEM_ALIGNMENT,RCV_LENGTH * sizeof(cl_uint*)); // host memory for output vector
    cl_mem d_R_x;                         // device memory used for a vector

    cl_uint* h_R_y_output = (cl_uint*)aligned_alloc(MEM_ALIGNMENT,RCV_LENGTH * sizeof(cl_uint*)); // host memory for output vector
    cl_mem d_R_y;                         // device memory used for a vector

    cl_uint* h_R_z_output = (cl_uint*)aligned_alloc(MEM_ALIGNMENT,RCV_LENGTH * sizeof(cl_uint*)); // host memory for output vector
    cl_mem d_R_z;                         // device memory used for a vector

    if (argc != 2) {
        printf("Usage: %s xclbin\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Fill our data sets with pattern
    h_data = (cl_uint*)aligned_alloc(MEM_ALIGNMENT,MAX_LENGTH * sizeof(cl_uint*));

    for(cl_uint i = 0; i < (MAX_LENGTH); i++) {
        h_x_n_input[i] = 0;
    }

    for(cl_uint i = 0; i < MAX_LENGTH; i++) {
        h_data[i]  = i;
        h_G_x_input[i] = 0; 
        h_G_y_input[i] = 0; 
    }
    
    for(cl_uint i = 0; i < RCV_LENGTH; i++) {
        h_R_x_output[i] = 0xFF; 
        h_R_y_output[i] = 0xFF; 
        h_R_z_output[i] = 0xFF; 

    }

    // Get all platforms and then select Xilinx platform
    cl_platform_id platforms[16];       // platform id
    cl_uint platform_count;
    cl_uint platform_found = 0;
    err = clGetPlatformIDs(16, platforms, &platform_count);
    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to find an OpenCL platform!\n");
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }
    printf("INFO: Found %d platforms\n", platform_count);

    // Find Xilinx Plaftorm
    for (cl_uint iplat=0; iplat<platform_count; iplat++) {
        err = clGetPlatformInfo(platforms[iplat], CL_PLATFORM_VENDOR, 1000, (void *)cl_platform_vendor,NULL);
        if (err != CL_SUCCESS) {
            printf("ERROR: clGetPlatformInfo(CL_PLATFORM_VENDOR) failed!\n");
            printf("ERROR: Test failed\n");
            return EXIT_FAILURE;
        }
        if (strcmp(cl_platform_vendor, "Xilinx") == 0) {
            printf("INFO: Selected platform %d from %s\n", iplat, cl_platform_vendor);
            platform_id = platforms[iplat];
            platform_found = 1;
        }
    }
    if (!platform_found) {
        printf("ERROR: Platform Xilinx not found. Exit.\n");
        return EXIT_FAILURE;
    }

    // Get Accelerator compute device
    cl_uint num_devices;
    cl_uint device_found = 0;
    cl_device_id devices[16];  // compute device id
    char cl_device_name[1001];
    err = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_ACCELERATOR, 16, devices, &num_devices);
    printf("INFO: Found %d devices\n", num_devices);
    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to create a device group!\n");
        printf("ERROR: Test failed\n");
        return -1;
    }

    //iterate all devices to select the target device.
    for (cl_uint i=0; i<num_devices; i++) {
        err = clGetDeviceInfo(devices[i], CL_DEVICE_NAME, 1024, cl_device_name, 0);
        if (err != CL_SUCCESS) {
            printf("ERROR: Failed to get device name for device %d!\n", i);
            printf("ERROR: Test failed\n");
            return EXIT_FAILURE;
        }
        printf("CL_DEVICE_NAME %s\n", cl_device_name);
        if(strcmp(cl_device_name, target_device_name) == 0) {
            device_id = devices[i];
            device_found = 1;
            printf("Selected %s as the target device\n", cl_device_name);
        }
    }

    if (!device_found) {
        printf("ERROR:Target device %s not found. Exit.\n", target_device_name);
        return EXIT_FAILURE;
    }

    // Create a compute context
    //
    context = clCreateContext(0, 1, &device_id, NULL, NULL, &err);
    if (!context) {
        printf("ERROR: Failed to create a compute context!\n");
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    // Create a command commands
    commands = clCreateCommandQueue(context, device_id, CL_QUEUE_PROFILING_ENABLE | CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE, &err);
    if (!commands) {
        printf("ERROR: Failed to create a command commands!\n");
        printf("ERROR: code %i\n",err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    cl_int status;

    // Create Program Objects
    // Load binary from disk
    unsigned char *kernelbinary;
    char *xclbin = argv[1];

    //------------------------------------------------------------------------------
    // xclbin
    //------------------------------------------------------------------------------
    printf("INFO: loading xclbin %s\n", xclbin);
    cl_uint n_i0 = load_file_to_memory(xclbin, (char **) &kernelbinary);
    if (n_i0 < 0) {
        printf("ERROR: failed to load kernel from xclbin: %s\n", xclbin);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    size_t n0 = n_i0;

    // Create the compute program from offline
    program = clCreateProgramWithBinary(context, 1, &device_id, &n0,
                                        (const unsigned char **) &kernelbinary, &status, &err);
    free(kernelbinary);

    if ((!program) || (err!=CL_SUCCESS)) {
        printf("ERROR: Failed to create compute program from binary %d!\n", err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }


    // Build the program executable
    //
    err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
    if (err != CL_SUCCESS) {
        size_t len;
        char buffer[2048];

        printf("ERROR: Failed to build program executable!\n");
        clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, sizeof(buffer), buffer, &len);
        printf("%s\n", buffer);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    // Create the compute kernel in the program we wish to run
    //
    kernel = clCreateKernel(program, "MSM_dummy", &err);
    if (!kernel || err != CL_SUCCESS) {
        printf("ERROR: Failed to create compute kernel!\n");
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    printf("\nPress ENTER to continue after setting up ILA trigger...");
    getc(stdin);

    // Create structs to define memory bank mapping
    cl_mem_ext_ptr_t mem_ext;
    mem_ext.obj = NULL;
    mem_ext.param = kernel;


    mem_ext.flags = 1;
    d_x_n = clCreateBuffer(context,  CL_MEM_READ_ONLY | CL_MEM_EXT_PTR_XILINX,  sizeof(cl_uint) * number_of_words_sent, &mem_ext, &err);
    if (err != CL_SUCCESS) {
      std::cout << "Return code for clCreateBuffer flags=" << mem_ext.flags << ": " << err << std::endl;
    }


    mem_ext.flags = 2;
    d_G_x = clCreateBuffer(context,  CL_MEM_READ_ONLY | CL_MEM_EXT_PTR_XILINX,  sizeof(cl_uint) * number_of_words_sent, &mem_ext, &err);
    if (err != CL_SUCCESS) {
      std::cout << "Return code for clCreateBuffer flags=" << mem_ext.flags << ": " << err << std::endl;
    }


    mem_ext.flags = 3;
    d_G_y = clCreateBuffer(context,  CL_MEM_READ_ONLY | CL_MEM_EXT_PTR_XILINX,  sizeof(cl_uint) * number_of_words_sent, &mem_ext, &err);
    if (err != CL_SUCCESS) {
      std::cout << "Return code for clCreateBuffer flags=" << mem_ext.flags << ": " << err << std::endl;
    }


    mem_ext.flags = 4;
    d_R_x = clCreateBuffer(context,  CL_MEM_WRITE_ONLY | CL_MEM_EXT_PTR_XILINX,  sizeof(cl_uint) * number_of_words_rcv, &mem_ext, &err);
    if (err != CL_SUCCESS) {
      std::cout << "Return code for clCreateBuffer flags=" << mem_ext.flags << ": " << err << std::endl;
    }


    mem_ext.flags = 5;
    d_R_y = clCreateBuffer(context,  CL_MEM_WRITE_ONLY | CL_MEM_EXT_PTR_XILINX,  sizeof(cl_uint) * number_of_words_rcv, &mem_ext, &err);
    if (err != CL_SUCCESS) {
      std::cout << "Return code for clCreateBuffer flags=" << mem_ext.flags << ": " << err << std::endl;
    }


    mem_ext.flags = 6;
    d_R_z = clCreateBuffer(context,  CL_MEM_WRITE_ONLY | CL_MEM_EXT_PTR_XILINX,  sizeof(cl_uint) * number_of_words_rcv, &mem_ext, &err);
    if (err != CL_SUCCESS) {
      std::cout << "Return code for clCreateBuffer flags=" << mem_ext.flags << ": " << err << std::endl;
    }


    if (!(d_x_n&&d_G_x&&d_G_y&&d_R_x&&d_R_y&&d_R_z)) {
        printf("ERROR: Failed to allocate device memory!\n");
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    // Copy from host to device memory 
    err = clEnqueueWriteBuffer(commands, d_x_n, CL_TRUE, 0, sizeof(cl_uint) * number_of_words_sent, h_data, 0, NULL, NULL);
    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to write to source array h_data: d_x_n: %d!\n", err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }


    err = clEnqueueWriteBuffer(commands, d_G_x, CL_TRUE, 0, sizeof(cl_uint) * number_of_words_sent, h_data, 0, NULL, NULL);
    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to write to source array h_data: d_G_x: %d!\n", err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }


    err = clEnqueueWriteBuffer(commands, d_G_y, CL_TRUE, 0, sizeof(cl_uint) * number_of_words_sent, h_data, 0, NULL, NULL);
    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to write to source array h_data: d_G_y: %d!\n", err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    clFinish(commands);
    printf("Finished enqueuing buffers\n");

    // Set the arguments to our compute kernel
    // cl_uint vector_length = MAX_LENGTH;
    err = 0;
    cl_uint d_n = 0;
    err |= clSetKernelArg(kernel, 0, sizeof(cl_uint), &d_n); // Not used in example RTL logic.
    err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), &d_x_n); 
    err |= clSetKernelArg(kernel, 2, sizeof(cl_mem), &d_G_x); 
    err |= clSetKernelArg(kernel, 3, sizeof(cl_mem), &d_G_y); 
    err |= clSetKernelArg(kernel, 4, sizeof(cl_mem), &d_R_x); 
    err |= clSetKernelArg(kernel, 5, sizeof(cl_mem), &d_R_y); 
    err |= clSetKernelArg(kernel, 6, sizeof(cl_mem), &d_R_z); 

    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to set kernel arguments! %d\n", err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    size_t global[1];
    size_t local[1];
    
    // Execute the kernel over the entire range of our 1d input data set
    // using the maximum number of work group items for this device

    /* Not recommended by Xilinx:
    global[0] = 1;
    local[0] = 1;
    err = clEnqueueNDRangeKernel(commands, kernel, 1, NULL, (size_t*)&global, (size_t*)&local, 0, NULL, NULL); */
    err = clEnqueueTask(commands, kernel, 0, NULL, NULL);
    if (err) {
        printf("ERROR: Failed to execute kernel! %d\n", err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    printf("Executed kernel!\n");
    clFinish(commands);
    printf("Executed finished commands!\n");

    // Read back the results from the device to verify the output
    //
    cl_event readevent;

    err = 0;
  
    err |= clEnqueueReadBuffer( commands, d_R_x, CL_TRUE, 0, sizeof(cl_uint) * number_of_words_rcv, h_R_x_output, 0, NULL, &readevent );

    err |= clEnqueueReadBuffer( commands, d_R_y, CL_TRUE, 0, sizeof(cl_uint) * number_of_words_rcv, h_R_y_output, 0, NULL, &readevent );

    err |= clEnqueueReadBuffer( commands, d_R_z, CL_TRUE, 0, sizeof(cl_uint) * number_of_words_rcv, h_R_z_output, 0, NULL, &readevent );


    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to read output array! %d\n", err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    printf("Enqueued read buffers, waiting for readevent!\n");
    clWaitForEvents(1, &readevent);
    // Check Results

    printf("Readed!\n");
  

    for (cl_uint i = 0; i < number_of_words_rcv; i++) {
        if (((h_data[i] + 1) != h_R_x_output[i]) && (i%4096==0)) {
            printf("ERROR in MSM_dummy::m03_axi - array index %d (host addr 0x%03x) - input=%d (0x%x), output=%d (0x%x)\n", i, i*4, h_data[i], h_data[i], h_R_x_output[i], h_R_x_output[i]);
            check_status = 1;
        }
      //  printf("i=%d, input=%d, output=%d\n", i,  h_R_x_input[i], h_R_x_output[i]);
    }


    for (cl_uint i = 0; i < number_of_words_rcv; i++) {
        if ((h_data[i] + 1) != h_R_y_output[i]) {
            //printf("ERROR in MSM_dummy::m04_axi - array index %d (host addr 0x%03x) - input=%d (0x%x), output=%d (0x%x)\n", i, i*4, h_data[i], h_data[i], h_R_y_output[i], h_R_y_output[i]);
            check_status = 1;
        }
      //  printf("i=%d, input=%d, output=%d\n", i,  h_R_y_input[i], h_R_y_output[i]);
    }


    for (cl_uint i = 0; i < number_of_words_rcv; i++) {
        if ((h_data[i] + 1) != h_R_z_output[i]) {
            //printf("ERROR in MSM_dummy::m05_axi - array index %d (host addr 0x%03x) - input=%d (0x%x), output=%d (0x%x)\n", i, i*4, h_data[i], h_data[i], h_R_z_output[i], h_R_z_output[i]);
            check_status = 1;
        }
      //  printf("i=%d, input=%d, output=%d\n", i,  h_R_z_input[i], h_R_z_output[i]);
    }


    //--------------------------------------------------------------------------
    // Shutdown and cleanup
    //-------------------------------------------------------------------------- 
    clReleaseMemObject(d_x_n);
    free(h_x_n_input);

    clReleaseMemObject(d_G_x);
    free(h_G_x_input);

    clReleaseMemObject(d_G_y);
    free(h_G_y_input);

    clReleaseMemObject(d_R_x);
    free(h_R_x_output);

    clReleaseMemObject(d_R_y);
    free(h_R_y_output);

    clReleaseMemObject(d_R_z);
    free(h_R_z_output);



    free(h_data);
    clReleaseProgram(program);
    clReleaseKernel(kernel);
    clReleaseCommandQueue(commands);
    clReleaseContext(context);

    if (check_status) {
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    } else {
        printf("INFO: Test completed successfully.\n");
        return EXIT_SUCCESS;
    }


} // end of main
