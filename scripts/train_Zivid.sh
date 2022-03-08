#! /bin/bash
export PATH_POSTFIX=$1
export MISC_ARGS=$2

export DATA_ROOT="/cluster/home/jonassaa/jobs/FCGF/outputs/ZividExperiment/"
export DATASET=${DATASET:-ZividPairDataset}
export MODEL=${MODEL:-ResUNetBN2C}
export MODEL_N_OUT=${MODEL_N_OUT:-32}
export INLIER_MODEL=${INLIER_MODEL:-ResUNetBN2C}
export OPTIMIZER=${OPTIMIZER:-SGD}
export LR=${LR:-1e-1}
export MAX_EPOCH=${MAX_EPOCH:-100}
export BATCH_SIZE=${BATCH_SIZE:-4}
export ITER_SIZE=${ITER_SIZE:-1}
export VOXEL_SIZE=${VOXEL_SIZE:-0.005}
export POSITIVE_PAIR_SEARCH_VOXEL_SIZE_MULTIPLIER=${POSITIVE_PAIR_SEARCH_VOXEL_SIZE_MULTIPLIER:-4}
export CONV1_KERNEL_SIZE=${CONV1_KERNEL_SIZE:-7}
export EXP_GAMMA=${EXP_GAMMA:-0.99}
export RANDOM_SCALE=${RANDOM_SCALE:-True}
export TIME=$(date +"%Y-%m-%d_%H-%M-%S")
export VERSION=$(git rev-parse HEAD)

#Avoid warning
export OMP_NUM_THREADS=12

export OUT_DIR=${DATA_ROOT}/${DATASET}-v${VOXEL_SIZE}/${INLIER_MODEL}/${OPTIMIZER}-lr${LR}-e${MAX_EPOCH}-b${BATCH_SIZE}i${ITER_SIZE}-modelnout${MODEL_N_OUT}${PATH_POSTFIX}/${TIME}

export PYTHONUNBUFFERED="True"

echo $OUT_DIR

mkdir -m 755 -p $OUT_DIR

LOG=${OUT_DIR}/log_${TIME}.txt

echo "Host: " $(hostname) | tee -a $LOG
echo $(pwd) | tee -a $LOG
echo "Version: " $VERSION | tee -a $LOG
#echo "Git diff" | tee -a $LOG
#echo "" | tee -a $LOG
#git diff | tee -a $LOG
echo "" | tee -a $LOG
nvidia-smi | tee -a $LOG


# Training
echo "############################################################"| tee -a $LOG
echo "                        TRAINING"| tee -a $LOG
echo "############################################################"| tee -a $LOG
python train.py \
  --dataset ZividPairDataset \
  --zivid_dataset_dir "/cluster/home/jonassaa/jobs/ZividOne_v1/" \
  --batch_size ${BATCH_SIZE} \
  --max_epoch ${MAX_EPOCH} \
  --voxel_size ${VOXEL_SIZE} \
  --out_dir ${OUT_DIR} \
  --use_random_scale ${RANDOM_SCALE} | tee -a $LOG
