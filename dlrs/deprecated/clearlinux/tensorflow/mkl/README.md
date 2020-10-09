# Deep Learning Reference Stack with TensorFlow and Intel® oneAPI Deep Neural Network Library (oneDNN)

[![](https://images.microbadger.com/badges/image/sysstacks/dlrs-tensorflow-clearlinux:v0.6.0.svg)](https://microbadger.com/images/sysstacks/dlrs-tensorflow-clearlinux:v0.6.0 "Get your own image badge on microbadger.com")

### Building Locally

Default build args in Docker are on: https://docs.docker.com/engine/reference/builder/#arg

>NOTE: This command is for locally building this image alone.

```
docker build --no-cache --build-arg clear_ver="32690" -t dlrs-tensorflow-clearlinux:v0.6.0 .
```

### Build ARGs

* `clear_ver` specifies the latest validated Clearlinux version for this DLRS Dockerfile.
>NOTE: Changing this version may result in errors, if you want to upgrade the OS version, you should use `swupd_args` instead.

* `swupd_args` specifies [swupd update](https://github.com/clearlinux/swupd-client/blob/master/docs/swupd.1.rst#options) flags passed to the update during build.

>NOTE: An empty `swupd_args` will default to 32690. Consider this when building as an OS upgrade won't be performed. If you'd like to upgrade the OS version, you can either do it manually inside a running container or add `swupd_args="<desired version>"` to the build command. The latest validated version is 32690, using a different one might result in unexpected errors.

_________________________________________________________________________________________________________________________________

## Using the Intel® OpenVINO Model Optimizer

The Intel OpenVINO toolkit has two primary tools for Deep Learning, the inference engine and the model optimzer. The inference engine is integrated into the Deep Learning Reference Stack, however the model optimizer is better used separately post training before inference begins. This tutorial will explain how to use the model optimizer by going through a test case with a pre-trained TensorFlow model.

This guide will use resources found in the OpenVino Toolkit documentation. Original documentation is here:

[Converting a TensorFlow Model](https://docs.openvinotoolkit.org/latest/_docs_MO_DG_prepare_model_convert_model_Convert_Model_From_TensorFlow.html) - Where to download supported topologies

[Converting TensorFlow Object Detection API Models](https://docs.openvinotoolkit.org/latest/_docs_MO_DG_prepare_model_convert_model_tf_specific_Convert_Object_Detection_API_Models.html) - Instructions on converting specific models


### Overview

In this tutorial, you will:
1. Download a TensorFlow model
2. Clone the Model Optimizer
3. Install Prerequisites
4. Run the Model Optimizer


### Requirements

This tutorial assumes development on a linux OS with a terminal dev environment. The tutorial was tested in Ubuntu 18.04.2.

### Download a TensorFlow model

We will be using an OpenVINO supported topology with the Model Optimizer. We will use a TensorFlow Inception V2 frozen model.

Navigate to the [OpenVINO TensorFlow Model page.](https://docs.openvinotoolkit.org/latest/_docs_MO_DG_prepare_model_convert_model_Convert_Model_From_TensorFlow.html) Then scroll down to the second section titled "Supported Frozen Topologies from TensorFlow Object Detection Models Zoo" and download "SSD Inception V2 COCO."

Unpack the file into your chosen working directory. For example, if the tar file is in your Downloads folder and you have navigated to the directory you want to extract it into, run:
```
tar -xvf ~/Downloads/ssd_inception_v2_coco_2018_01_28.tar.gz
```

### Clone the Model Optimizer

Next we need the model optimizer directory, named dldt, found [here.](https://github.com/opencv/dldt) This guide will assume the parent directory is on the same level as the model directory, ie:
```
.
+--Working_Directory
   +-- ssd_inception_v2_coco_2018_01_28
   +-- dldt
```

From inside the working directory:

```
git clone https://github.com/opencv/dldt.git
```

If you explore the dldt directory, you'll see both the inference engine and the model optimizer. We are only concerned with the model optimizer. Navigating into the model optimizer folder you'll find several python scripts and text files. These are the scripts you call to run the model optimizer.


### Install Prerequisites

Install the Python packages required to run the model optimizer by running the script dldt/model-optimizer/install_prerequisites/install_prerequisites_tf.sh.
```
cd dldt/model-optimizer/install_prerequisites/
./install_prerequisites_tf.sh
cd ../../..
```


### Run the Model Optimizer

Running the model optimizer is as simple as calling the appropriate script, however there are many configuration options that are explained [here.](https://docs.openvinotoolkit.org/latest/_docs_MO_DG_prepare_model_convert_model_tf_specific_Convert_Object_Detection_API_Models.html)

```
python dldt/model-optimizer/mo_tf.py \
--input_model=ssd_inception_v2_coco_2018_01_28/frozen_inference_graph.pb \
--tensorflow_use_custom_operations_config dldt/model-optimizer/extensions/front/tf/ssd_v2_support.json \
--tensorflow_object_detection_api_pipeline_config ssd_inception_v2_coco_2018_01_28/pipeline.config \
--reverse_input_channels
```

You should now see three files in your working directory, frozen_inference_graph.bin, frozen_inference_graph.mapping, and frozen_inference_graph.xml. These are your new models in the Intermediate Representation (IR) format and they are ready for use in the OpenVINO Inference Engine.

_________________________________________________________________________________________________________________________________

## Using the OpenVino Inference Engine

Basic example on how to run the inference engine on your local machine

### Starting the Model Server

The process is similar to how we start `Jupter notebooks` on our containers

Run this command to spin up a OpenVino model fetched from GCP

```bash
docker run -p 8000:8000 stacks-tensorflow-mkl:latest bash -c ". /workspace/scripts/serve.sh && ie_serving model --model_name resnet --model_path gs://public-artifacts/intelai_public_models/resnet_50_i8 --port 8000"

```

Once the server is setup, use a `grpc` client to communicate with served model, here is an example:


```
git clone https://github.com/IntelAI/OpenVINO-model-server.git
cd OpenVINO-model-server
pip install -q -r OpenVINO-model-server/example_client/client_requirements.txt
pip install --user -q -r OpenVINO-model-server/example_client/client_requirements.txt
cat OpenVINO-model-server/example_client/client_requirements.txt
cd OpenVINO-model-server/example_client

python jpeg_classification.py --images_list input_images.txt --grpc_address localhost --grpc_port 8000 --input_name data --output_name prob --size 224 --model_name resnet
```

You should get an output like:

```
start processing:
	Model name: resnet
	Images list file: input_images.txt
images/airliner.jpeg (1, 3, 224, 224) ; data range: 0.0 : 255.0
Processing time: 97.00 ms; speed 2.00 fps 10.35
Detected: 404  Should be: 404
images/arctic-fox.jpeg (1, 3, 224, 224) ; data range: 0.0 : 255.0
Processing time: 16.00 ms; speed 2.00 fps 63.89
Detected: 279  Should be: 279
images/bee.jpeg (1, 3, 224, 224) ; data range: 0.0 : 255.0
Processing time: 14.00 ms; speed 2.00 fps 69.82
Detected: 309  Should be: 309
images/golden_retriever.jpeg (1, 3, 224, 224) ; data range: 0.0 : 255.0
Processing time: 13.00 ms; speed 2.00 fps 75.22
Detected: 207  Should be: 207
images/gorilla.jpeg (1, 3, 224, 224) ; data range: 0.0 : 255.0
Processing time: 11.00 ms; speed 2.00 fps 87.24
Detected: 366  Should be: 366
images/magnetic_compass.jpeg (1, 3, 224, 224) ; data range: 0.0 : 247.0
Processing time: 11.00 ms; speed 2.00 fps 91.07
Detected: 635  Should be: 635
images/peacock.jpeg (1, 3, 224, 224) ; data range: 0.0 : 255.0
Processing time: 9.00 ms; speed 2.00 fps 110.1
Detected: 84  Should be: 84
images/pelican.jpeg (1, 3, 224, 224) ; data range: 0.0 : 255.0
Processing time: 10.00 ms; speed 2.00 fps 103.63
Detected: 144  Should be: 144
images/snail.jpeg (1, 3, 224, 224) ; data range: 0.0 : 248.0
Processing time: 10.00 ms; speed 2.00 fps 104.33
Detected: 113  Should be: 113
images/zebra.jpeg (1, 3, 224, 224) ; data range: 0.0 : 255.0
Processing time: 12.00 ms; speed 2.00 fps 83.04
Detected: 340  Should be: 340
Overall accuracy= 100.0 %
Average latency= 19.8 ms
```
