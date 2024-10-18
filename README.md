# Satellite Planning Under Uncertainty

This project involves optimizing satellite planning under uncertain conditions using **SCIP** and **ZIMPL**.

## Install

**SCIP** (Solving Constraint Integer Programs) is optimization software that allows you to solve mixed-integer linear and nonlinear optimization problems.

**ZIMPL** is a mathematical modeling language that helps in formulating optimization problems, which can then be solved using solvers like SCIP.

### Installation Steps

1. **Download the SCIP Optimization Suite**

   Download the `.deb` package for Ubuntu 22.04 from the official SCIP website:

   [SCIPOptSuite-9.1.1-Linux-ubuntu22.deb](https://www.scipopt.org/download.php?fname=SCIPOptSuite-9.1.1-Linux-ubuntu22.deb)

2. **Install the Package**

   Open a terminal and navigate to the directory where you downloaded the `.deb` file.

   ```bash
   sudo dpkg -i SCIPOptSuite-9.1.1-Linux-ubuntu22.deb
   ```

   If you encounter any dependency issues, run: 
   ```bash
   sudo apt-get install -f
   ```

3. **Test if It Works**
    ```bash
   $ scip
   SCIP version 9.1.1 [precision: 8 byte] [memory: block] [mode: optimized] [LP solver: Soplex 7.1.1] [GitHash: 66f11a6724]
   Copyright (c) 2002-2024 Zuse Institute Berlin (ZIB)
   ```

   ```bash
   $ zimpl -help
   ****************************************************
   * Zuse Institute Mathematical Programming Language *
   * Release 3.6.2 Copyright (C)2018 by Thorsten Koch *
   ****************************************************
   *   This is free software and you are welcome to   *
   *     redistribute it under certain conditions     *
   *      ZIMPL comes with ABSOLUTELY NO WARRANTY     *
   ****************************************************
   ```
   
