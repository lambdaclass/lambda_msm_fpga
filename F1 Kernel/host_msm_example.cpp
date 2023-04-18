#include <iostream>
#include <stdlib.h>
#include "xcl2.hpp"

////////////////////////////////////////////////////////////////////////////////
#define MAX_LENGTH (4096 << 4) // 4096 points; 16 cl_uints per coordinate
#define RCV_LENGTH (256 << 4)  // 256 points; 16 cl_uints per coordinate
#define MEM_ALIGNMENT 4096


////////////////////////////////////////////////////////////////////////////////

int main(int argc, char** argv)
{

    cl_int err;                            // error code returned from api calls
    cl_uint check_status = 0;
    const cl_uint number_of_words_sent = MAX_LENGTH; //
    const cl_uint number_of_words_rcv = RCV_LENGTH;

    cl::Context context;          // compute context
    cl::CommandQueue commands;    // compute command queue
    cl::Kernel kernel;            // compute kernel

    cl_uint* h_data;              // host memory for input vector

    cl_uint* h_x_n_input = (cl_uint*)aligned_alloc(MEM_ALIGNMENT, MAX_LENGTH * sizeof(cl_uint*)); // host memory for input vector of scalars
    cl_uint* h_G_x_input = (cl_uint*)aligned_alloc(MEM_ALIGNMENT, MAX_LENGTH * sizeof(cl_uint*)); // host memory for input vector of X coordinate
    cl_uint* h_G_y_input = (cl_uint*)aligned_alloc(MEM_ALIGNMENT, MAX_LENGTH * sizeof(cl_uint*)); // host memory for input vector of Y coordinate
    cl_uint* h_R_x_output = (cl_uint*)aligned_alloc(MEM_ALIGNMENT, RCV_LENGTH * sizeof(cl_uint*)); // host memory for output vector of X coordinate
    cl_uint* h_R_y_output = (cl_uint*)aligned_alloc(MEM_ALIGNMENT, RCV_LENGTH * sizeof(cl_uint*)); // host memory for output vector of Y coordinate
    cl_uint* h_R_z_output = (cl_uint*)aligned_alloc(MEM_ALIGNMENT, RCV_LENGTH * sizeof(cl_uint*)); // host memory for output vector of Z coordinate

    if (argc != 2) {
        printf("Usage: %s xclbin\n", argv[0]);
        return EXIT_FAILURE;
    }
    char *xclbin = argv[1];

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


    // OPENCL HOST CODE AREA START
    // get_xil_devices() is a utility API which will find the xilinx
    // platforms and will return list of devices connected to Xilinx platform
    auto devices = xcl::get_xil_devices();
    // read_binary_file() is a utility API which will load the binaryFile
    // and will return the pointer to file buffer.
    auto fileBuf = xcl::read_binary_file(xclbin); //binaryFile
    cl::Program::Binaries bins{{fileBuf.data(), fileBuf.size()}};
    bool valid_device = false;
    for (unsigned int i = 0; i < devices.size(); i++) {
        auto device = devices[i];
        // Creating Context and Command Queue for selected Device
        OCL_CHECK(err, context = cl::Context(device, nullptr, nullptr, nullptr, &err));
        OCL_CHECK(err, commands = cl::CommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &err));
        std::cout << "Trying to program device[" << i << "]: " << device.getInfo<CL_DEVICE_NAME>() << std::endl;
        cl::Program program(context, {device}, bins, nullptr, &err);
        if (err != CL_SUCCESS) {
            std::cout << "Failed to program device[" << i << "] with xclbin file!\n";
        } else {
            std::cout << "Device[" << i << "]: program successful!\n";
            OCL_CHECK(err, kernel = cl::Kernel(program, "MSM_dummy", &err));
            valid_device = true;
            break; // we break because we found a valid device
        }
    }
    if (!valid_device) {
         std::cout << "Failed to program any device found, exit!\n";
         exit(EXIT_FAILURE);
    }

    // Setup ChipScope
    printf("\nPress ENTER to continue after setting up ILA trigger...");
    getc(stdin);


    // Allocate Buffer in Global Memory
    // Buffers are allocated using CL_MEM_USE_HOST_PTR for efficient memory and
    // Device-to-host communication
    OCL_CHECK(err, cl::Buffer d_x_n(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY, sizeof(cl_uint) * number_of_words_sent,//vector_size_bytes,
    							    h_x_n_input, &err));
    OCL_CHECK(err, cl::Buffer d_G_x(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY, sizeof(cl_uint) * number_of_words_sent,//vector_size_bytes,
    								h_G_x_input, &err));
    OCL_CHECK(err, cl::Buffer d_G_y(context, CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY, sizeof(cl_uint) * number_of_words_sent,//vector_size_bytes,
                 				    h_G_y_input, &err));
    OCL_CHECK(err, cl::Buffer d_R_x(context, CL_MEM_USE_HOST_PTR | CL_MEM_WRITE_ONLY, sizeof(cl_uint) * number_of_words_rcv,//vector_size_bytes,
                                    h_R_x_output, &err));
    OCL_CHECK(err, cl::Buffer d_R_y(context, CL_MEM_USE_HOST_PTR | CL_MEM_WRITE_ONLY, sizeof(cl_uint) * number_of_words_rcv,//vector_size_bytes,
                                    h_R_y_output, &err));
    OCL_CHECK(err, cl::Buffer d_R_z(context, CL_MEM_USE_HOST_PTR | CL_MEM_WRITE_ONLY, sizeof(cl_uint) * number_of_words_rcv,//vector_size_bytes,
                                    h_R_z_output, &err));


    // Set the arguments to our compute kernel
    err = 0;
    int size = MAX_LENGTH;
    OCL_CHECK(err, err = kernel.setArg(0, size));
    OCL_CHECK(err, err = kernel.setArg(1, d_x_n));
    OCL_CHECK(err, err = kernel.setArg(2, d_G_x));
    OCL_CHECK(err, err = kernel.setArg(3, d_G_y));
    OCL_CHECK(err, err = kernel.setArg(4, d_R_x));
    OCL_CHECK(err, err = kernel.setArg(5, d_R_y));
    OCL_CHECK(err, err = kernel.setArg(6, d_R_z));


    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to set kernel arguments! %d\n", err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    // Copy input data to device global memory
    OCL_CHECK(err, err = commands.enqueueMigrateMemObjects({d_x_n, d_G_x, d_G_y}, 0 /* 0 means from host*/));

    //cl::Finish(commands);
    printf("Finished enqueuing buffers\n");

    // Launch kernel
    OCL_CHECK(err, err = commands.enqueueTask(kernel));
    printf("Launched kernel!\n");

    err = 0;

    // Copy results from device to host local memory
    OCL_CHECK(err, err = commands.enqueueMigrateMemObjects({d_R_x,d_R_y,d_R_z}, CL_MIGRATE_MEM_OBJECT_HOST));

    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to read output array! %d\n", err);
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    }

    printf("Enqueued read command, waiting for buffers to be read...\n");
    OCL_CHECK(err, err = commands.finish());
    printf("Read done!\n");

    // Check Results

    for (cl_uint i = 0; i < number_of_words_rcv; i++) {
        if (((h_data[i] + 1) != h_R_x_output[i])&& (i%4096==0)) {
            printf("ERROR in MSM_dummy::m03_axi - array index %d (host addr 0x%03x) - input=%d (0x%x), output=%d (0x%x)\n", i, i*4, h_data[i], h_data[i], h_R_x_output[i], h_R_x_output[i]);
            check_status = 1;
        }
      //  printf("i=%d, input=%d, output=%d\n", i,  h_R_x_input[i], h_R_x_output[i]);
    }

    //--------------------------------------------------------------------------
    // Shutdown and cleanup
    //-------------------------------------------------------------------------- 
    //clReleaseMemObject(d_x_n);
    free(h_x_n_input);

    //clReleaseMemObject(d_G_x);
    free(h_G_x_input);

    //clReleaseMemObject(d_G_y);
    free(h_G_y_input);

    //clReleaseMemObject(d_R_x);
    free(h_R_x_output);

    //clReleaseMemObject(d_R_y);
    free(h_R_y_output);

    //clReleaseMemObject(d_R_z);
    free(h_R_z_output);



    free(h_data);
    //clReleaseProgram(program);
    //clReleaseKernel(kernel);
    //clReleaseCommandQueue(commands);
    //clReleaseContext(context);

    if (check_status) {
        printf("ERROR: Test failed\n");
        return EXIT_FAILURE;
    } else {
        printf("INFO: Test completed successfully.\n");
        return EXIT_SUCCESS;
    }


} // end of main


