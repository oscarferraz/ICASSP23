NCCOMPILE = mo.py

YELLOW='\033[1;33m'
NOCOLOR='\033[0m'
RED = '\033[1;31m'

VERSION?=v4
MODEL_CKPT=${MODEL_NAME}

# Inception model names as defined in https://github.com/tensorflow/models/blob/master/research/slim/nets/nets_factory.py
MODEL_NAME=inception_${VERSION}

IMGSIZE=299
MODEL_CKPT_TAR=${MODEL_CKPT}_2016_09_09.tar.gz
MODEL_CKPT_AFTER_TAR=${MODEL_CKPT}_2016_09_09.ckpt
OUTPUT_NODE_NAME=InceptionV4/Logits/Predictions

MODEL_RELATIVE_DIR=model/${VERSION}

GRAPH_FILENAME_BASE = inception_${VERSION}_frozen

SIMPLE_CLASSIFIER_CPP_RELATIVE_DIR = ../../apps/simple_classifier_cpp
SIMPLE_CLASSIFIER_PY_RELATIVE_DIR = ../../apps/simple_classifier_py
TEST_IMAGE_RELATIVE_DIR = ../../data/images
TEST_IMAGE_FILENAME = nps_electric_guitar.png

PROJECT_DIR = ${CURDIR}
ZOO_RELATIVE_TF_SRC_PROJ = ../tf_src
ZOO_RELATIVE_TF_MODELS_PROJ = ../tf_models
ZOO_TF_SRC_PATH = ${PROJECT_DIR}/${ZOO_RELATIVE_TF_SRC_PROJ}/tensorflow
ZOO_TF_MODELS_PATH = ${PROJECT_DIR}/${ZOO_RELATIVE_TF_MODELS_PROJ}/models

MEAN_VALUES = [128,128,128]
SCALE = 128

IR = ${MODEL_RELATIVE_DIR}/${GRAPH_FILENAME_BASE}.xml
IMAGE = ${TEST_IMAGE_RELATIVE_DIR}/${TEST_IMAGE_FILENAME}
LABELS = categories.txt

NETWORK_NAME = inception_v4


.PHONY: all
all: deps data compile_model compile_cpp

# Checks if TF_MODELS_PATH is set.  If it isn't set then will make the
# tf_models project in the ncappzoo/tensorflow/tf_models directory.
check_model:
ifndef TF_MODELS_PATH
	@echo $(YELLOW)"TF_MODELS_PATH not set, making tf_models..."$(NOCOLOR);
	(cd ../tf_models; make all; cd ${PROJECT_DIR})
	$(eval TF_MODELS_PATH = ${ZOO_TF_MODELS_PATH})
	@echo "TF_MODELS_PATH is ${TF_MODELS_PATH}" ;
else
	@echo "TF_MODELS_PATH is ${TF_MODELS_PATH}" ;
endif

# Checks if TF_SRC_PATH is set.  If it isn't set then will make the
# tf_models project in the ncappzoo/tensorflow/tf_src directory.
check_tf:
ifndef TF_SRC_PATH
	@echo $(YELLOW)"TF_SRC_PATH not set, making tf_src..."$(NOCOLOR);
	(cd ../tf_src; make all; cd ${PROJECT_DIR})
	$(eval TF_SRC_PATH=${ZOO_TF_SRC_PATH})
	@echo "TF_SRC_PATH is ${TF_SRC_PATH}" ;
else
	@echo "TF_SRC_PATH is ${TF_SRC_PATH}" ;
endif


.PHONY: deps
deps: freeze
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Making dependencies..."$(NOCOLOR)


.PHONY: data
data: 
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Downloading required data for model - No data needed."$(NOCOLOR)

.PHONY: checkpoint
checkpoint:
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Downloading checkpoint file..."$(NOCOLOR)
	@if [ -e ${MODEL_RELATIVE_DIR}/${MODEL_CKPT_AFTER_TAR} ] ; \
	then \
		echo " - Checkpoint file already exists, skipping checkpoint."; \
	else \
		mkdir -p model/${VERSION}; \
		cd ${MODEL_RELATIVE_DIR}; \
		wget -nc http://download.tensorflow.org/models/${MODEL_CKPT_TAR}; \
		tar -xvf ${MODEL_CKPT_TAR}; \
		cd ../..; \
	fi;
	
	
.PHONY: export
export: check_model
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Exporting GraphDef file..."$(NOCOLOR)
	@if [ -e ${MODEL_RELATIVE_DIR}/${MODEL_CKPT}.pb ] ; \
	then \
		echo "No export needed."; \
	else \
		cd ${MODEL_RELATIVE_DIR}; \
		python3 ${TF_MODELS_PATH}/research/slim/export_inference_graph.py \
			--alsologtostderr \
			--model_name=${MODEL_NAME} \
			--batch_size=1 \
			--dataset_name=imagenet \
			--image_size=${IMGSIZE} \
			--output_file=${MODEL_CKPT}.pb; \
		cd ../..; \
	fi;


.PHONY: freeze
freeze: check_tf checkpoint export
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Freezing model for inference..."$(NOCOLOR)
	@if [ -e ${MODEL_RELATIVE_DIR}/${MODEL_CKPT}_frozen.pb ] ; \
	then \
		echo " - Frozen model file already exists, skipping freeze."; \
	else \
		cd ${MODEL_RELATIVE_DIR}; \
		python3 ${TF_SRC_PATH}/tensorflow/python/tools/freeze_graph.py \
			--input_graph=${MODEL_CKPT}.pb \
			--input_binary=true \
			--input_checkpoint=${MODEL_CKPT}.ckpt \
			--output_graph=${MODEL_CKPT}_frozen.pb \
			--output_node_name=${OUTPUT_NODE_NAME}; \
		cd ../..; \
	fi;


.PHONY: compile_model
compile_model: freeze
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Compiling model to IR..."$(NOCOLOR)
	@echo "Checking OpenVINO environment..."
	@if [ -z "$(INTEL_OPENVINO_DIR)" ] ; \
	then \
		echo "Please initiate the Intel OpenVINO environment by going to the installation directory for openvino and running the setupvars.sh file in the bin folder." ; \
		exit 1 ; \
	else \
		echo "Intel OpenVINO environment is already set!" ; \
	fi
	@if [ -e ${MODEL_RELATIVE_DIR}/${GRAPH_FILENAME_BASE}.xml ] && [ -e ${MODEL_RELATIVE_DIR}/${GRAPH_FILENAME_BASE}.bin ]  ; \
	then \
		echo " - Compiled model file already exists, skipping compile."; \
	else \
		cd ${MODEL_RELATIVE_DIR}; \
		${NCCOMPILE} --data_type=FP16 --reverse_input_channels --scale=${SCALE} --mean_values=${MEAN_VALUES} --input_model=${MODEL_CKPT}_frozen.pb || (echo $(RED)"Make sure to set the OpenVINO environment variables using the "$(YELLOW)"setupvars.sh"$(RED)" script found in <your OpenVINO install location>/bin/ folder."$(NOCOLOR);  exit 1;); \
	fi;

	
.PHONY: run
run: run_py


.PHONY:	compile_cpp
compile_cpp:  
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Compiling C++ sample..."$(NOCOLOR)
	@echo "Checking OpenVINO environment..."
	@if [ -z "$(INTEL_OPENVINO_DIR)" ] ; \
	then \
		echo "Please initiate the Intel OpenVINO environment by going to the installation directory for openvino and running the setupvars.sh file in the bin folder." ; \
		exit 1 ; \
	else \
		echo "Intel OpenVINO environment is already set!" ; \
	fi
	(cd ${SIMPLE_CLASSIFIER_CPP_RELATIVE_DIR}; make compile_cpp; cd -)


.PHONY: run_cpp
run_cpp: data deps compile_cpp compile_model
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Running C++ sample..."$(NOCOLOR)
	${SIMPLE_CLASSIFIER_CPP_RELATIVE_DIR}/build/simple_classifier_cpp ${IR} ${IMAGE} ${LABELS}; 


.PHONY: run_py
run_py: data deps compile_model
	@echo $(YELLOW) '\n'${NETWORK_NAME}": Running Python sample..." $(NOCOLOR)
	#python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${IMAGE} --labels=${LABELS}; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_acoustic_guitar.png --labels=${LABELS} --top=5; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_backpack.png --labels=${LABELS} --top=5; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_baseball.png --labels=${LABELS} --top=5; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_chair.png --labels=${LABELS} --top=5; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_electric_guitar.png --labels=${LABELS} --top=5; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_guac.png --labels=${LABELS} --top=5; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_keyboard.png --labels=${LABELS} --top=5; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_mouse.png --labels=${LABELS} --top=5; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_mug.png --labels=${LABELS} --top=5; 
	python3 ${SIMPLE_CLASSIFIER_PY_RELATIVE_DIR}/run.py --ir=${IR} --image=${TEST_IMAGE_RELATIVE_DIR}/nps_screwdriver.png --labels=${LABELS} --top=5;  



.PHONY: install-reqs
install-reqs: 
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Checking application requirements...\n"$(NOCOLOR)
	@echo "No requirements needed."
	
	
.PHONY: uninstall-reqs
uninstall-reqs: 
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Uninstalling requirements..."$(NOCOLOR)
	@echo "Nothing to uninstall."
	
	
.PHONY: help
help:
	@echo "\nPossible make targets: ";
	@echo $(YELLOW)"  make run "$(NOCOLOR)"- Runs Python example.";
	@echo $(YELLOW)"  make run_py "$(NOCOLOR)"- Runs Python example.";
	@echo $(YELLOW)"  make run_cpp "$(NOCOLOR)"- Runs C++ example.";
	@echo $(YELLOW)"  make help "$(NOCOLOR)"- Shows this message.";
	@echo $(YELLOW)"  make all "$(NOCOLOR)"- Makes everything needed to run, but doesn't run.";
	@echo $(YELLOW)"  make compile_model "$(NOCOLOR)"- Runs model compiler for the network.";
	@echo $(YELLOW)"  make compile_cpp "$(NOCOLOR)"- Builds C++ example to demonstrate the network.";
	@echo $(YELLOW)"  make data "$(NOCOLOR)"- Downloads required data.";
	@echo $(YELLOW)"  make deps "$(NOCOLOR)"- Makes dependencies for project, prepares model etc.";
	@echo $(YELLOW)"  make install-reqs "$(NOCOLOR)"- Installs requirements needed to run this sample on your system.";
	@echo $(YELLOW)"  make uninstall-reqs "$(NOCOLOR)"- Uninstalls requirements that were installed by the sample program.";
	@echo $(YELLOW)"  make clean "$(NOCOLOR)"- Removes files created in this directory.\n";
	@echo " ----- "$(YELLOW)"Model information"$(NOCOLOR)" -----"
	@echo $(YELLOW)" Description: "$(NOCOLOR)
	@echo "  This network does image classification on 1000 different classes.";
	@echo $(YELLOW)" Model inputs:"$(NOCOLOR)
	@echo "  name: 'input', shape: [1x3x299x299], Expected color order is BGR after optimization.";
	@echo $(YELLOW)" Model outputs:"$(NOCOLOR)
	@echo "  name: 'InceptionV4/Predictions/Softmax', shape: [1, 1001] - Output indexes represent each class probability.\n";



.PHONY: clean
clean:
	@echo $(YELLOW)'\n'${NETWORK_NAME}": Cleaning up files..."$(NOCOLOR);
	rm -rf model
