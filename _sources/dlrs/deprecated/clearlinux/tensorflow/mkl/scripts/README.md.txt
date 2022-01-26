## Deep Learning Reference Stack Scripts

The Deep Learning Reference Stack, is an integrated, highly-performant open source stack optimized for Intel® Xeon® Scalable platforms.
This open source community release is part of an effort to ensure AI developers have easy access to all features and functionality of Intel platforms.
Highly-tuned and built for cloud native environments, the release enables developers to quickly prototype by reducing complexity associated with integrating
multiple software components, while still giving users the flexibility to customize their solutions.

### Sanity checks

DLRS requires availability of AVX512 instructions on your machine, you can test if your platform has these instructions by running the script:

```bash
/bin/bash ./check_avx512.sh
```
if the platform is supported you will get a message:

```bash
==============================================================================================
Fri 12 Jul 2019 02:53:47 PM PDT -- [Done]: Success, the platform supports AVX-512 instructions
==============================================================================================
```

### Tweaking performance

We have also added a script to set a number of environment variables which can be tweaked based on the workload to optimize performance. You can source these variables using:

Topologies supported

- Vision models (ResNet50 and Inception)
- ResNet101
- Wide and Deep Models
- Language
- Default (if the workload is a custom model)

```bash
source ./set_env.sh

Set default runtime  params when using Intel® DLRS stack.
We recommend you fine tune the exported env variables based on the workload
More details can be found at: https://github.com/IntelAI/models/blob/master/docs/general/tensorflow_serving/GeneralBestPractices.md

Supported models
- vision
- resnet101
- langauge
- wide_deep
- default

What type of model are you trying to run? vision
===========================================================================
Fri 12 Jul 2019 02:56:36 PM PDT -- Setting default params for vision models
===========================================================================
==================================================
Fri 12 Jul 2019 02:56:36 PM PDT --  Parameters Set
==================================================
BATCH_SIZE :: 128
DATA_LAYOUT :: NCHW
OMP_NUM_THREADS :: 10
KMP_BLOCKTIME :: 2
KMP_AFFINITY :: granularity=fine,verbose,compact,1,0
INTER_OP_PARALLELISM_THREADS :: 1
INTRA_OP_PARALLELISM_THREADS :: 10
TENSORFLOW_INTRA_OP_PARALLELISM :: 10
TENSORFLOW_INTER_OP_PARALLELISM :: 1
```

This is only a helper script, for you to get started, we recommend you fine tune the exported environment variables based on your workload.
More details can be found at General best practices [page](https://github.com/IntelAI/models/blob/master/docs/general/tensorflow_serving/GeneralBestPractices.md).

### Mailing List

See our public [mailing list](https://lists.01.org/postorius/lists/stacks.lists.01.org/) page for details on how to contact us. You should only subscribe to the Stacks mailing lists using an email address that you don't mind being public.
